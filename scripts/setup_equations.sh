

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw / (17.8846 - 0.01306 * raw)",
	"description": "equação de conversão dos valores da umidade do chão, solo davis",
	"sensor": "02",
	"measurementUnit": "0e"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw * 1",
	"description": "equação de conversão dos valores de conexao",
	"sensor": "07",
	"measurementUnit": "0d"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "20.25 * raw - 8.1",
	"description": "equação de conversão dos valores do anemômetro",
	"sensor": "02",
	"measurementUnit": "09"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw * 1",
	"description": "equação de conversão dos valores da bateria",
	"sensor": "03",
	"measurementUnit": "0e"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw * 598.8024",
	"description": "equação de conversão dos valores da placa solar",
	"sensor": "02",
	"measurementUnit": "08"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw * 1",
	"description": "equação de conversão dos valores de temperatura do SHT35",
	"sensor": "06",
	"measurementUnit": "00"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw * 1",
	"description": "equação de conversão dos valores de temperatura do BME",
	"sensor": "00",
	"measurementUnit": "00"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw * 1",
	"description": "equação de conversão dos valores de temperatura do BMP",
	"sensor": "01",
	"measurementUnit": "00"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw * 1",
	"description": "equação de conversão dos valores de umidade do SHT35",
	"sensor": "06",
	"measurementUnit": "03"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw * 1",
	"description": "equação de conversão dos valores de umidade do BME",
	"sensor": "06",
	"measurementUnit": "03"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw * 1",
	"description": "equação de conversão dos valores de chuva",
	"sensor": "05",
	"measurementUnit": "0a"
}'

curl --request POST \
  --url http://nimbus.smap.agr.br:8080/equation \
  --header 'Content-Type: application/json' \
  --data '{
	"equation": "raw * 1",
	"description": "equação de conversão dos valores de pressao atmosferica",
	"sensor": "00",
	"measurementUnit": "07"
}'