import boto3
import os
import json
import urllib3

def lambda_handler(event, context):
    sns_client = boto3.client('sns')
    topic_arn = os.environ.get('SNS_TOPIC_ARN')
    
    # Coordinates for Novi Sad, Serbia
    lat, lon = 45.2517, 19.8369
    # Fetching weather for tomorrow (index 1 in the daily array)
    url = f"https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto"

    http = urllib3.PoolManager()
    
    try:
        response = http.request('GET', url)
        data = json.loads(response.data.decode('utf-8'))
        
        tomorrow_max = data['daily']['temperature_2m_max'][1]
        tomorrow_min = data['daily']['temperature_2m_min'][1]
        rain_prob = data['daily']['precipitation_probability_max'][1]
        
        message = (
            f"Hello, World!\n\n"
            f"Here is your automated forecast for Novi Sad tomorrow:\n"
            f"️High: {tomorrow_max}°C\n"
            f"Low: {tomorrow_min}°C\n"
            f"️Rain Probability: {rain_prob}%\n\n"
            f"Have a great day ahead!"
        )

        sns_client.publish(
            TopicArn=topic_arn,
            Message=message,
            Subject="Daily Weather Update: Novi Sad"
        )
        
        return {'statusCode': 200, 'body': 'Weather notification sent successfully!'}
        
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        return {'statusCode': 500, 'body': 'Failed to fetch weather data.'}