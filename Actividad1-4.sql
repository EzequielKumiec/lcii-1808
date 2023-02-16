--------------------------------------------------------------------------------
--                                 ACTIVIDAD 1.4                              --
--------------------------------------------------------------------------------

--3. Se quiere saber la fecha de la primera venta, la cantidad total vendida y
--el importe total vendido por vendedor para los casos en que el promedio
--de la cantidad vendida sea inferior o igual a 56.
--------------------------------------------------------------------------------

--select min(fecha) 'Primera Venta',
--	   sum(cantidad) 'Cantidad total',
--	   sum(cantidad * pre_unitario) 'importe total',
--	   v.nom_vendedor + ', ' + v.ape_vendedor 'Vendedor'
--from facturas f 
--	join detalle_facturas df on df.nro_factura = f.nro_factura
--	join vendedores v on f.cod_vendedor = v.cod_vendedor
--group by fecha,v.nom_vendedor + ', ' + v.ape_vendedor
--having avg(cantidad) <= 56
--and fecha = min(fecha)
--------------------------------------------------------------------------------
--4. Se necesita un listado que informe sobre el monto máximo, mínimo y
--total que gastó en esta librería cada cliente el año pasado, pero solo
--donde el importe total gastado por esos clientes esté entre 300 y 800.
--------------------------------------------------------------------------------

SELECT max(pre_unitario) 'Monto maximo',
	   min(pre_unitario) 'Monto minimo',
	   sum(pre_unitario * cantidad) 'Total',
	   c.nom_cliente 'Cliente',
	   fecha 'Fecha'
from facturas f 
	join detalle_facturas df on df.nro_factura = f.nro_factura
	join clientes c on c.cod_cliente = f.cod_cliente
group by nom_cliente, fecha
having sum(pre_unitario * cantidad) between 300 and 800
--------------------------------------------------------------------------------
--5. Muestre la cantidad facturas diarias por vendedor; para los casos en que
--esa cantidad sea 2 o más.
--------------------------------------------------------------------------------

select count(f.nro_factura) 'Cantidad de facturas',
	   v.nom_vendedor 'Vendedor',
	   convert(char,fecha,103) 'Fecha'
from facturas f 
	join detalle_facturas df on df.nro_factura = f.nro_factura
	join vendedores v on v.cod_vendedor= f.cod_vendedor
group by nom_vendedor, fecha
having count(f.nro_factura) >= 2
--------------------------------------------------------------------------------
--6. Desde la administración se solicita un reporte que muestre el precio
--promedio, el importe total y el promedio del importe vendido por artículo
--que no comiencen con “c”, que su cantidad total vendida sea 100 o más
--o que ese importe total vendido sea superior a 700.

-------------------------------Detalle--------------------------------------------

select a.descripcion 'Articulo',
	   avg(df.pre_unitario) 'precio promedio',
	   sum(cantidad * df.pre_unitario) 'Importe total',
	   avg(cantidad * df.pre_unitario) 'promedio importe vendido'
from facturas f 
	join detalle_facturas df on df.nro_factura = f.nro_factura
	join articulos a on a.cod_articulo = df.cod_articulo
where a.descripcion not like 'c%'
group by a.descripcion
having sum(cantidad) >= 100 or sum(cantidad * df.pre_unitario) > 700

----------------------------Articulo---------------------------------------------

select a.descripcion 'Articulo',
	   avg(a.pre_unitario) 'precio promedio',
	   sum(cantidad * a.pre_unitario) 'Importe total',
	   avg(cantidad * df.pre_unitario) 'promedio importe vendido'
from facturas f 
	join detalle_facturas df on df.nro_factura = f.nro_factura
	join articulos a on a.cod_articulo = df.cod_articulo
where a.descripcion not like 'c%'
group by a.descripcion
having sum(cantidad) >= 100 or sum(cantidad * df.pre_unitario) > 700
--------------------------------------------------------------------------------
--7. Muestre en un listado la cantidad total de artículos vendidos, el importe
--total y la fecha de la primer y última venta por cada cliente, para lo
--números de factura que no sean los siguientes: 2, 12, 20, 17, 30 y que el
--promedio de la cantidad vendida oscile entre 2 y 6.
--------------------------------------------------------------------------------

select df.nro_factura 'Numero de Factura',
	   count(df.nro_factura) 'Articulos vendidos',
	   sum(cantidad * pre_unitario) 'importe total',
	   min(fecha) 'Primer venta',
	   max(fecha) 'ultima venta',
	   c.nom_cliente 'Cliente'
from facturas f 
	join detalle_facturas df on df.nro_factura = f.nro_factura
	join clientes c on c.cod_cliente = f.cod_cliente
where df.nro_factura not in (2,12,20,17,30)
group by df.nro_factura, fecha, nom_cliente
having avg(cantidad * df.pre_unitario) between 2 and 6
--------------------------------------------------------------------------------
--8. Emitir un listado que muestre la cantidad total de artículos vendidos, el
--importe total vendido y el promedio del importe vendido por vendedor y 
--por cliente; para los casos en que el importe total vendido esté entre 200
--y 600 y para códigos de cliente que oscilen entre 1 y 5.
--------------------------------------------------------------------------------

select df.nro_factura 'Numero de Factura',
	   sum(df.nro_factura) 'Total de articulos vendidos',
	   sum(cantidad * df.pre_unitario) 'Importe total vendido',
	   avg(cantidad * df.pre_unitario) 'Promedio importe vendido',
	   c.nom_cliente + ', ' + c.ape_cliente 'Cliente',
	   c.cod_cliente 'Codigo cliente',
	   v.nom_vendedor + ', ' + v.ape_vendedor 'Vendedor'
from facturas f 
	join detalle_facturas df on df.nro_factura = f.nro_factura
	join clientes c on c.cod_cliente = f.cod_cliente
	join vendedores v on v.cod_vendedor = f.cod_vendedor
where c.cod_cliente between 1 and 5
group by df.nro_factura,c.nom_cliente + ', ' + c.ape_cliente,c.cod_cliente,v.nom_vendedor + ', ' + v.ape_vendedor
having sum(cantidad * pre_unitario) between 200 and 600
--------------------------------------------------------------------------------
--9. ¿Cuáles son los vendedores cuyo promedio de facturación el mes
--pasado supera los $ 800?
--------------------------------------------------------------------------------

select v.nom_vendedor + ', ' + v.ape_vendedor 'Vendedor',
	   convert(char,fecha,103) 'Fecha',
	   avg(cantidad * df.pre_unitario) 'Promedio importe vendido'
from facturas f 
	join detalle_facturas df on df.nro_factura = f.nro_factura
	join vendedores v on v.cod_vendedor = f.cod_vendedor
where month(fecha) = month(getdate())-1
group by v.nom_vendedor + ', ' + v.ape_vendedor, fecha
having avg(cantidad * df.pre_unitario) > 800
order by 3
--------------------------------------------------------------------------------
--10.¿Cuánto le vendió cada vendedor a cada cliente el año pasado siempre
--que la cantidad de facturas emitidas (por cada vendedor a cada cliente)
--sea menor a 5?
--------------------------------------------------------------------------------

select count(df.nro_factura) 'Total de articulos vendidos',
	   sum(cantidad * df.pre_unitario) 'Importe total vendido',
	   convert(char,fecha,103) 'Fecha',
	   c.nom_cliente + ', ' + c.ape_cliente 'Cliente',
	   v.nom_vendedor + ', ' + v.ape_vendedor 'Vendedor'
from facturas f 
	join detalle_facturas df on df.nro_factura = f.nro_factura
	join clientes c on c.cod_cliente = f.cod_cliente
	join vendedores v on v.cod_vendedor = f.cod_vendedor
where YEAR(fecha) = YEAR(getdate())-1
group by c.nom_cliente + ', ' + c.ape_cliente ,
	   v.nom_vendedor + ', ' + v.ape_vendedor,
	   fecha
having count(df.nro_factura) <5

-----------------------------------------------------------------------------------------
--                                    Ezek                                             --
-----------------------------------------------------------------------------------------
