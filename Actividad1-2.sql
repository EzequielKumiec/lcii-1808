---------------------------------ACTIVIDAD 1.2---------------------------------

-------------------------------------------------------------------------------
--7. Se quiere saber la cantidad de ventas que hizo el vendedor de código 3.
-------------------------------------------------------------------------------

select count(*)
from detalle_facturas df
	join facturas f on f.nro_factura = df.nro_factura
	join vendedores v on v.cod_vendedor = f.cod_vendedor
where v.cod_vendedor = 3


-------------------------------------------------------------------------------
--8. ¿Cuál fue la fecha de la primera y última venta que se realizó en este
--negocio?
-------------------------------------------------------------------------------

select max(fecha) 'Ultima venta', 
	   min(fecha) 'Primera venta'
from facturas


-------------------------------------------------------------------------------
--9. Mostrar la siguiente información respecto a la factura nro.: 450: cantidad
--total de unidades vendidas, la cantidad de artículos diferentes vendidos y
--el importe total.
-------------------------------------------------------------------------------

select sum(cantidad) 'Cantidad total de unidades vendidas',
	   count(distinct df.cod_articulo) 'Articulos diferentes vendidos',
	   sum(pre_unitario * cantidad) 'Importe total'
from detalle_facturas df
	join facturas f on f.nro_factura = df.nro_factura
where f.nro_factura = 450

-------------------------------------------------------------------------------
--10.¿Cuál fue la cantidad total de unidades vendidas, importe total y el
--importe promedio para vendedores cuyos nombres comienzan con letras
--que van de la “d” a la “l”?
-------------------------------------------------------------------------------

select count(cantidad) 'Cantidad total de unidades vendidas',
	   sum(pre_unitario * cantidad) 'Importe total'
from detalle_facturas df
	join facturas f on f.nro_factura = df.nro_factura
	join vendedores v on v.cod_vendedor = f.cod_vendedor
where v.nom_vendedor like '[d-l]%'

-------------------------------------------------------------------------------
--11.Se quiere saber el importe total vendido, el promedio del importe vendido
--y la cantidad total de artículos vendidos para el cliente Roque Paez.
-------------------------------------------------------------------------------

select * from clientes

select sum(cantidad * pre_unitario) 'Importe Total',
	   --sum(cantidad * pre_unitario)/ count(distinct df.nro_factura) 'promedio Importe por factura',
	   round(avg(cantidad * pre_unitario),3) 'Promedio Importe total por detalle de factura',  --el round(avg(), num) es para sacarle los numeros despues de la coma
	   sum(cantidad) 'Cantidad de Articulos'

from detalle_facturas df
	join facturas f on f.nro_factura = df.nro_factura
	join clientes c on f.cod_cliente = c.cod_cliente 
where nom_cliente like '%Roque%'

-------------------------------------------------------------------------------
--12.Mostrar la fecha de la primera venta, la cantidad total vendida y el importe
--total vendido para los artículos que empiecen con “C”.
-------------------------------------------------------------------------------

select convert(char,min(f.fecha),103) 'Primera venta',
	   sum(cantidad) 'Cantidad total vendida',
	   sum(df.pre_unitario * cantidad) 'importe total vendida'
from detalle_facturas df
	join facturas f on f.nro_factura = df.nro_factura
	join articulos a on a.cod_articulo = df.cod_articulo
where a.descripcion like 'C%' 

-------------------------------------------------------------------------------
--13.Se quiere saber la cantidad total de artículos vendidos y el importe total
--vendido para el periodo del 15/06/2011 al 15/06/2017.
-------------------------------------------------------------------------------

select sum(cantidad) 'Cantidad total de articulos vendidos',
	   sum(cantidad * pre_unitario) 'importe total'

from detalle_facturas df
	join facturas f on f.nro_factura = df.nro_factura
where f.fecha > 15/06/2011 --and f.fecha <15/06/2017    NO HAY NADA ENTRE ESA FECHA


-------------------------------------------------------------------------------
--14.Se quiere saber la cantidad de veces y la última vez que vino el cliente de
--apellido Abarca y cuánto gastó en total.
-------------------------------------------------------------------------------

select count(c.cod_cliente) 'Cantidad de veces que vino',
	   max(f.fecha) 'Ultima vez que vino',
	   sum(cantidad * pre_unitario) 'Gasto total'
from detalle_facturas df
	join facturas f on f.nro_factura = df.nro_factura
	join clientes c on f.cod_cliente = c.cod_cliente 
where c.ape_cliente = 'Abarca'

-------------------------------------------------------------------------------
--15.Mostrar el importe total y el promedio del importe para los clientes cuya
--dirección de mail es conocida.
-------------------------------------------------------------------------------

select sum(pre_unitario * cantidad) 'importe total',
	   avg(pre_unitario * cantidad) 'promedio del importe'
from detalle_facturas df
	join facturas f on f.nro_factura = df.nro_factura
	join clientes c on f.cod_cliente = c.cod_cliente 
where c.[e-mail] is not null

-------------------------------------------------------------------------------
--16.Obtener la siguiente información: el importe total vendido y el importe
--promedio vendido para números de factura que no sean los siguientes:
--13, 5, 17, 33, 24
-------------------------------------------------------------------------------
select sum(pre_unitario * cantidad) 'importe total',
	   avg(pre_unitario * cantidad) 'promedio del importe'
from detalle_facturas df
	join facturas f on f.nro_factura = df.nro_factura
where f.nro_factura not like '[13,5,17,33,24]'
