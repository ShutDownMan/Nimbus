
curl --request PATCH \
  --url http://nimbus.smap.agr.br:8080/measure \
  --header 'Content-Type: application/json' \
  --data '{
	"code": "00",
	"name": "Temperature",
	"description": "How hot is it?"
}'

curl --request PATCH \
  --url http://nimbus.smap.agr.br:8080/measure \
  --header 'Content-Type: application/json' \
  --data '{
	"code": "0d",
	"name": "Connection",
	"description": "How well can the station hear the acess point."
}'

curl --request PATCH \
  --url http://nimbus.smap.agr.br:8080/measure \
  --header 'Content-Type: application/json' \
  --data '{
	"code": "09",
	"name": "Wind Velocity",
	"description": "How fast is the wind going."
}'

curl --request PATCH \
  --url http://nimbus.smap.agr.br:8080/measure \
  --header 'Content-Type: application/json' \
  --data '{
	"code": "0e",
	"name": "Voltage",
	"description": "How hard does it zap."
}'

curl --request PATCH \
  --url http://nimbus.smap.agr.br:8080/measure \
  --header 'Content-Type: application/json' \
  --data '{
	"code": "08",
	"name": "Irradiance",
	"description": "How sunny is it."
}'

curl --request PATCH \
  --url http://nimbus.smap.agr.br:8080/measure \
  --header 'Content-Type: application/json' \
  --data '{
	"code": "0a",
	"name": "Rain",
	"description": "How much did it rain."
}'