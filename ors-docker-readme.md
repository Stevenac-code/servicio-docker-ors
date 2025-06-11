# OpenRouteService (ORS) - Guía de Configuración con Docker

Esta guía explica cómo configurar y ejecutar OpenRouteService utilizando Docker, incluyendo configuraciones personalizadas para el servicio de matriz.

## Documentación Oficial

Para más información, consulta la documentación oficial: [OpenRouteService - Running with Docker](https://giscience.github.io/openrouteservice/run-instance/running-with-docker)

## Requisitos Previos

- Docker Desktop instalado y en ejecución
- PowerShell (para Windows) o terminal (para Linux/macOS)

## Paso 1: Descargar el archivo docker-compose.yml

### En Windows (PowerShell):
```powershell
Invoke-WebRequest -Uri "https://github.com/GIScience/openrouteservice/releases/download/v8.0.0/docker-compose.yml" -OutFile "docker-compose.yml"
```

### En Linux/macOS:
```bash
wget https://github.com/GIScience/openrouteservice/releases/download/v8.0.0/docker-compose.yml
```

## Paso 2: Ejecutar OpenRouteService

⚠️ **IMPORTANTE**: Asegúrate de que Docker Desktop esté ejecutándose antes de continuar.

### Iniciar el servicio

Ejecuta uno de los siguientes comandos desde la carpeta donde descargaste el `docker-compose.yml`:

```bash
# Sin logs (en segundo plano)
docker compose up -d

# Con logs (para ver la salida en tiempo real)
docker compose up
```

### Ver logs del contenedor
```bash
docker compose logs -tf
```

### Detener el servicio
```bash
docker compose down
```

## Comandos Útiles de Docker

### Gestión de contenedores
```bash
# Ver contenedores en ejecución
docker ps -a

# Detener todos los contenedores
docker stop $(docker ps -q)

# Eliminar todos los contenedores
docker rm $(docker ps -a -q)
```

## Configuración Personalizada

Para usar configuraciones personalizadas, reemplaza el contenido del archivo `docker-compose.yml` con la siguiente configuración:

```yaml
# Docker Compose file for the openrouteservice (ORS) application
# Documentation and examples can be found on https://giscience.github.io/openrouteservice/run-instance/running-with-docker

services:
  # ----------------- ORS application configuration ------------------- #
  ors-app:
    # Activate the following lines to build the container from the repository
    # You have to add --build to the docker compose command to do so
    build:
      context: ./
    container_name: ors-app
    ports:
      - "8080:8082"  # Expose the ORS API on port 8080
      - "9001:9001"  # Expose additional port for monitoring (optional)
    image: openrouteservice/openrouteservice:v9.2.0
    
    volumes: # Mount relative directories. ONLY for local container runtime
      - ./config:/home/ors/config  # Mount configuration directory individually
      - ./logs:/home/ors/logs  # Mount logs directory individually
      - ./files:/home/ors/files  # Mount files directory individually
    
    environment:
      REBUILD_GRAPHS: False  # Set to True to rebuild graphs on container start
      CONTAINER_LOG_LEVEL: INFO
      ORS_CONFIG_LOCATION: /home/ors/config/my-ors-config.yml
      
      # ------------------ JAVA OPTS ------------------ #
      XMS: 1g  # start RAM assigned to java
      XMX: 2g  # max RAM assigned to java
      ADDITIONAL_JAVA_OPTS: ""
```

## Configuración del Archivo my-ors-config.yml

Crea un archivo `my-ors-config.yml` en la carpeta `config/` con la siguiente configuración de ejemplo:

```yaml
ors:
  engine:
    profile_default:
      build:
        source_file: /home/ors/files/colombia-latest.osm.pbf
    profiles:
      driving-car:
        enabled: true
  endpoints:
    matrix:
      maximum_routes: 500000
      maximum_visited_nodes: 1000000000
```

## Estructura de Directorios

Asegúrate de crear la siguiente estructura de directorios:

```
proyecto/
├── docker-compose.yml
├── config/
│   └── my-ors-config.yml
├── logs/
└── files/
    └── colombia-latest.osm.pbf (tu archivo de datos OSM)
```

## Configuración de Memoria

La configuración de memoria Java se calcula como:
```
XMX = <Tamaño del archivo PBF> × <Número de perfiles> × 2
```

**Ejemplo**: Para un archivo PBF de 1.5 GB con dos perfiles (car y foot-walking):
- 1.5 × 2 × 2 = 6 GB
- Configurar XMX a al menos `6g`

## Acceso al Servicio

Una vez que el contenedor esté ejecutándose, podrás acceder a:

- **API de OpenRouteService**: `http://localhost:8080`
- **Puerto de monitoreo** (opcional): `http://localhost:9001`

## Solución de Problemas

1. **Error "Docker daemon not running"**: Asegúrate de que Docker Desktop esté iniciado
2. **Problemas de memoria**: Ajusta los valores `XMS` y `XMX` según el tamaño de tus datos
3. **Archivos de configuración**: Verifica que los archivos estén en las rutas correctas dentro de las carpetas montadas

## Notas Adicionales

- El healthcheck está deshabilitado por defecto
- Para reconstruir los grafos, cambia `REBUILD_GRAPHS` a `True`
- Los logs se guardan en la carpeta `logs/` montada
- Los archivos de datos OSM deben ubicarse en la carpeta `files/`