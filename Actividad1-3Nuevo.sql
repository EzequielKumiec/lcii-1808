---------------------------------ACTIVIDAD 1.3---------------------------------

--2. Por cada factura emitida mostrar la cantidad total de artículos vendidos
--(suma de las cantidades vendidas), la cantidad ítems que tiene cada
--factura en el detalle (cantidad de registros de detalles) y el Importe total
--de la facturación de este año.
-------------------------------------------------------------------------------

select f.nro_factura 'Numero Factura',
	   sum(cantidad) 'Total de articulos vendidos',
	   count(f.nro_factura) 'Cantidad de items',
	   sum(df.pre_unitario * cantidad) 'importe total'
from facturas f
	join detalle_facturas df on f.nro_factura =df.nro_factura
	join articulos a on a.cod_articulo = df.cod_articulo
where year(fecha) = year(GETDATE()) 
group by f.nro_factura

-----------------------------------------------------------------------------

select sum(cantidad) 'Total de articulos vendidos',
	   count(distinct df.nro_factura) 'Cantidad de items',
	   sum(pre_unitario * cantidad) 'importe total'
from facturas f
	join detalle_facturas df on f.nro_factura =df.nro_factura
where year(fecha) = year(GETDATE()) 

-------------------------------------------------------------------------------
--3. Se quiere saber en este negocio, cuánto se factura:
--                   FIJARSE QUE MUESTRA TODAS LAS FECHAS, HABRIA QUE PONER UN WHERE PARA FILTRAR
-----------------------------------------------------------------------------
--a. Diariamente
-----------------------------------------------------------------------------
select convert(char,fecha,103) 'Fecha',sum(cantidad * pre_unitario) 'Se factura'
from facturas f
	join detalle_facturas df on f.nro_factura =df.nro_factura
group by fecha


-----------------------------------------------------------------------------
--b. Mensualmente
------------------------Con Nombre-------------------------------------------

select YEAR(fecha) AS Año, 
	   DATENAME(MONTH, MAX(fecha)) AS Mes,
	   sum(cantidad * pre_unitario) 'Se factura'
from facturas f
	join detalle_facturas df on f.nro_factura =df.nro_factura
group by
		year(fecha),
		month(fecha)
order by Año,Mes

-------------------------Sin Nombre------------------------------------------

select YEAR(fecha) AS Año, 
	   month(MAX(fecha)) AS Mes,
	   sum(cantidad * pre_unitario) 'Se factura'
from facturas f
	join detalle_facturas df on f.nro_factura =df.nro_factura
group by
		year(fecha),
		month(fecha)
order by Año,Mes

-----------------------------------------------------------------------------
--c. Anualmente
select YEAR(fecha) 'Fecha',sum(cantidad * pre_unitario) 'Se factura'
from facturas f
	join detalle_facturas df on f.nro_factura =df.nro_factura
group by  YEAR(fecha)
order by fecha
-------------------------------------------------------------------------------
--4. Emitir un listado de la cantidad de facturas confeccionadas diariamente,
--correspondiente a los meses que no sean enero, julio ni diciembre.
--Ordene por la cantidad de facturas en forma descendente y fecha.
-----------------------------------------------------------------------------

select convert(char,f.fecha,103) 'Fecha',
	   count(df.nro_factura) cuantos
from facturas f
	join detalle_facturas df on f.nro_factura =df.nro_factura
where month(f.fecha) not in (1,7,12)
	  and year(fecha) = 2021
group by f.nro_factura,f.fecha
order by cuantos desc, fecha asc
-----------------------------------------------------------------------------
--5. Se quiere saber la cantidad y el importe promedio vendido por fecha y
--cliente, para códigos de vendedor superiores a 2. Ordene por fecha y
--cliente.
-----------------------------------------------------------------------------


select v.nom_vendedor + ', ' + v.ape_vendedor 'Vendedor',
	   cantidad 'Cantidad',
	   sum(cantidad * df.pre_unitario)/count(df.nro_factura) 'Importe Promedio',
	   convert(char,fecha,103) 'Fecha',
	   c.nom_cliente + ', ' + c.ape_cliente 'Cliente'
from detalle_facturas df 
	 join facturas f on f.nro_factura = df.nro_factura
	 join clientes c on c.cod_cliente = f.cod_cliente
	 join vendedores v on v.cod_vendedor = f.cod_vendedor
where v.cod_vendedor > 2
group by nom_vendedor, ape_vendedor, f.fecha, nom_cliente,ape_cliente, cantidad
order by Fecha, Cliente
-----------------------------------------------------------------------------
--6. Se quiere saber el importe promedio vendido y la cantidad total vendida
--por fecha y artículo, para códigos de cliente inferior a 3. Ordene por fecha
--y artículo.
-----------------------------------------------------------------------------

select avg(df.pre_unitario*cantidad) 'Importe promedio',
	   avg(cantidad) 'Cantidad Promedio',
	   convert(char,fecha,103) 'Fecha',
	   a.descripcion 'Articulos'
from facturas f 
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join articulos a on a.cod_articulo = df.cod_articulo
	 join clientes c on c.cod_cliente = f.cod_cliente
where c.cod_cliente < 3
group by fecha,descripcion

-----------------------------------------------------------------------------
--7. Listar la cantidad total vendida, el importe total vendido y el importe
--promedio total vendido por número de factura, siempre que la fecha no
--oscile entre el 13/2/2007 y el 13/7/2010.
-----------------------------------------------------------------------------

select sum(cantidad) 'Cantidad Total',
	   sum(pre_unitario*cantidad) 'Importe total',
	   avg(cantidad*df.pre_unitario) 'Importe Promedio',
	   convert(char,fecha,103) 'Fecha'
from facturas f 
	 join detalle_facturas df on df.nro_factura = f.nro_factura
where fecha not between 13/2/2007 and 13/7/2010
group by fecha
-----------------------------------------------------------------------------
--8. Emitir un reporte que muestre la fecha de la primer y última venta y el
--importe comprado por cliente. Rotule como CLIENTE, PRIMER VENTA,
--ÚLTIMA VENTA, IMPORTE.
-----------------------------------------------------------------------------

select c.nom_cliente + ', ' +  c.ape_cliente 'Clientes',
	   min(convert(char,fecha,103)) 'Primera Venta', 
	   max(convert(char,fecha,103)) 'Ultima Venta',
	   sum(cantidad * df.pre_unitario) 'Importe'

from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join clientes c on c.cod_cliente = f.cod_cliente
GROUP BY c.nom_cliente + ', ' + c.ape_cliente, fecha
-----------------------------------------------------------------------------
--9. Se quiere saber el importe total vendido, la cantidad total vendida y el
--precio unitario promedio por cliente y artículo, siempre que el nombre del
--cliente comience con letras que van de la “a” a la “m”. Ordene por cliente,
--precio unitario promedio en forma descendente y artículo. Rotule como
--IMPORTE TOTAL, CANTIDAD TOTAL, PRECIO PROMEDIO.
-----------------------------------------------------------------------------

select c.nom_cliente + ', ' +  c.ape_cliente 'Clientes',
	   sum(df.pre_unitario * cantidad) 'Importe total',
	   sum(cantidad) 'Cantidad Total',
	   avg(a.pre_unitario) 'Precio promedio unitario por articulo',
	   avg(df.pre_unitario) 'Precio promedio unitario por detalle'
from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join clientes c on c.cod_cliente = f.cod_cliente
	 join articulos a on a.cod_articulo = df.cod_articulo
where c.nom_cliente like '[a-m]%'
group by c.nom_cliente + ', ' +  c.ape_cliente
order by 1,4 desc


-----------------------------------------------------------------------------
--10.Se quiere saber la cantidad de facturas y la fecha la primer y última
--factura por vendedor y cliente, para números de factura que oscilan entre
--5 y 30. Ordene por vendedor, cantidad de ventas en forma descendente y
--cliente.
--------------------------------------------------------------------------------
select count(df.nro_factura) 'Cantidad de facturas',
	   min(fecha) 'Primer factura',
	   max(fecha) 'Ultima factura',
	   c.nom_cliente + ', '+ c.ape_cliente 'Cliente',
	   v.nom_vendedor + ', ' + v.ape_vendedor 'Vendedores'
from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join clientes c on c.cod_cliente = f.cod_cliente
	 join vendedores v on v.cod_vendedor = f.cod_vendedor
where df.nro_factura between 5 and 30
group by df.nro_factura, c.nom_cliente + ', '+ c.ape_cliente, v.nom_vendedor + ', ' + v.ape_vendedor 
order by 4,5
--------------------------------------------------------------------------------
--                                   Clase                                    --
--------------------------------------------------------------------------------

select v.nom_vendedor 'Vendedores',
	   c.nom_cliente 'Clientes',
	   sum(cantidad*pre_unitario) 'Total',
	   convert(char,f.fecha,103) 'Fecha'
from vendedores v
	 join facturas f on f.cod_vendedor = v.cod_vendedor
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join clientes c on c.cod_cliente = f.cod_cliente
where year(f.fecha) = YEAR(GETDATE())-1
group by v.nom_vendedor, c.nom_cliente, f.fecha
order by f.fecha

------------------------------------------------------------------------------
select f.nro_factura, sum(pre_unitario*cantidad) 'Total'
from facturas f
	 join detalle_facturas df on f.nro_factura = df.nro_factura
group by f.nro_factura
having sum(pre_unitario*cantidad)between 550 and 870

-----------------------------------------------------------------------------

select v.nom_vendedor + ', '+ v.nom_vendedor 'Vendedor', sum(pre_unitario*cantidad) 'Total'
from facturas f
	 join detalle_facturas df on f.nro_factura = df.nro_factura
	 join vendedores v on v.cod_vendedor = f.cod_cliente
where year(fecha) = year(getdate())
	 --or year(fecha) = year(getdate())-1
group by v.nom_vendedor + ', '+ v.nom_vendedor
having sum(pre_unitario*cantidad)<135000

