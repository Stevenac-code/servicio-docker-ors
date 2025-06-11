import requests
import json

# URL local de tu instancia ORS
url = "http://54.211.136.80:8082/ors/v2/directions/driving-car"

6.237647,-75.573361
6.236226,-75.573272
# Coordenadas: [longitud, latitud]
body = {
    "coordinates": [
        [-75.573361, 6.237647],
        [-75.573272, 6.236226]
        
    ]
}


# body = {
#     "coordinates": [
#         [6.237647, -75.573361],
#         [6.236226,-75.573272]
        
#     ]
# }

headers = {
    "Content-Type": "application/json"
}

response = requests.post(url, headers=headers, json=body)

# Comprobamos si la respuesta fue exitosa
if response.status_code == 200:
    data = response.json()
    distancia = data['routes'][0]['summary']['distance'] / 1000  # km
    duracion = data['routes'][0]['summary']['duration'] / 3600  # horas
    print(f"Distancia: {distancia:.2f} km")
    print(f"Duración: {duracion:.2f} horas")
else:
    print(f"Error {response.status_code}: {response.text}")
