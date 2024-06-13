with placas_seq as (
  select placa,
         datahora, 
         rank() over (partition by placa order by datahora) as seq,
         camera_latitude,
         camera_longitude
  from rj-cetrio.desafio.readings_2024_06
  where camera_latitude between -23.09617 and -22.71584
  and camera_longitude between -43.83891 and -43.11669 -- aqui, fixei um retângulo contendo o rio de janeiro
  and datahora_captura between '2024-06-01 00:00:00' and '2024-06-30 23:59:59'
),     -- ordenando, por placa e tempo, os pontos por onde cada veículo passa
params as (
  select 
       o.placa as placa
    ,  st_geogpoint(o.camera_longitude, o.camera_latitude) as ponto_inicial
    ,  st_geogpoint(t.camera_longitude, t.camera_latitude) as ponto_final
    ,  o.datahora as t_inicial
    ,  t.datahora as t_final
    ,  st_distance(st_geogpoint(o.camera_longitude, o.camera_latitude), st_geogpoint(t.camera_longitude, t.camera_latitude), true) as delta_s
    ,  timestamp_diff(t.datahora, o.datahora, second) as delta_t
    ,  st_distance(st_geogpoint(o.camera_longitude, o.camera_latitude), st_geogpoint(t.camera_longitude, t.camera_latitude), true)/timestamp_diff(t.datahora, o.datahora, second) as velocidade_media
from placas_seq o join placas_seq t 
on o.placa = t.placa and o.seq + 1 = t.seq
) -- concatenando os pontos consecutivos (temporalmente) para formar trechos
select *
from params
where 
velocidade_media > 42 -- a placa é duplicada se a velocidade média exceder 42m/s