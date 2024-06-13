# Desafio Civitas
--------------------------------------------------------------------

### Setup
Primeiro, vamos contar o número de placas presentes no dataset:

```sql
select count(distinct placa) from rj-cetrio.desafio.readings_2024_06
```
Executando essa query, vemos que há um total de 7984610 (aproximadamente 8 milhões) de placas no banco de dados. 

Agora, vamos delimitar a cidade do Rio de Janeiro no mapa usando um retângulo. Isso será útil para vermos se há posições medidas que estão fora da cidade do Rio.

![Retângulo contendo a cidade do Rio](retangulo_rj.jpeg)

As coordenadas que limitam o retângulo são: latitude entre -23.09617 e -22.71584, longitude entre -43.83891 e -43.11669. Linhas com coordenadas fora deste retângulo serão descartadas da nossa análise, pois estas seriam erros de medida.

```sql
select count(1) from rj-cetrio.desafio.readings_2024_06
where not (camera_latitude between -23.09617 and -22.71584)
or not (camera_longitude between )
```