# Usa una imagen base que sea adecuada para Openrouteservice (e.g., la imagen oficial o una de OpenJDK)
FROM openrouteservice/openrouteservice:v9.2.0

# Copia tu archivo de configuración personalizado a la ubicación esperada dentro del contenedor
# Asegúrate de que la ruta de destino coincida con lo que esperas en ORS_CONFIG_LOCATION
COPY ./config/my-ors-config.yml /home/ors/config/my-ors-config.yml

# Copia el archivo PBF (mapa) a la ubicación esperada dentro del contenedor
COPY ./files/colombia-latest.osm.pbf /home/ors/files/colombia-latest.osm.pbf

# Si tienes otros archivos o directorios necesarios, cópialos de manera similar.
# Por ejemplo, si el directorio 'graphs' o 'elevation_cache' necesita ser pre-creado o si
# necesitas permisos específicos, asegúrate de ello. ORS generalmente los crea al inicio.

# Expon los puertos que Openrouteservice utiliza
EXPOSE 8082
EXPOSE 9001

# Define variables de entorno para la configuración de ORS si no están en tu ors-config.yml
# (Ya las tienes en la definición de tarea, pero es bueno tenerlas aquí como fallback o si el Dockerfile es independiente)
ENV REBUILD_GRAPHS=False
ENV CONTAINER_LOG_LEVEL=INFO
ENV ORS_CONFIG_LOCATION=/home/ors/config/my-ors-config.yml
ENV XMS=1536m
ENV XMX=4096m  
# Asegúrate de que XMX sea suficiente para tu archivo PBF. Tu JSON tiene 4096m.

# El entrypoint de la imagen base de openrouteservice se encarga de iniciar la aplicación.
# No necesitas un CMD o ENTRYPOINT explícito a menos que quieras anular el predeterminado.