import requests

def get_traffic_info(latitude, longitude, tomtom_api_key):
    endpoint = "https://api.tomtom.com/traffic/services/4/flowSegmentData/absolute/10/json"
    params = {
        'point': f'{latitude},{longitude}',
        'key': tomtom_api_key
    }
    response = requests.get(endpoint, params=params)
    if response.status_code == 200:
        data = response.json()
        current_speed = data.get('flowSegmentData', {}).get('currentSpeed')
        return current_speed
    else:
        print(f'Error fetching traffic info: {response.status_code}')
        return None

tomtom_api_key = 'K6XCzw97Ogk4D3domsrHaA6YC2hngIzB'
latitude = input("latitude : ")
longitude = input("longitude : ")
speed_limit = get_traffic_info(latitude, longitude, tomtom_api_key)
print(f'The speed limit is: {speed_limit} km/h')
