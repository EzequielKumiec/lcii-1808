--------------------------------------------------------------------------------------
--                         Actividad 2.2 Con Having xd                              --
--------------------------------------------------------------------------------------
--Los usuarios finales del sistema en esta oportunidad necesitan obtener los
--siguientes reportes de información para el funcionamiento del negocio y la toma de
--decisiones:
--------------------------------------------------------------------------------------
--1. Se quiere saber ¿cuándo realizó su primer venta cada vendedor? y
--¿cuánto fue el importe total de las ventas que ha realizado? Mostrar estos
--datos en un listado solo para los casos en que su importe promedio de
--vendido sea superior al importe promedio general (importe promedio de
--todas las facturas).
--------------------------------------------------------------------------------------

select v.nom_vendedor 'Vendedor',
	   min(fecha) 'Primera venta',
	   sum(cantidad * df.pre_unitario) 'Importe total'
from facturas f
	 join vendedores v on v.cod_vendedor = f.cod_vendedor
	 join detalle_facturas df on df.nro_factura = f.nro_factura
group by nom_vendedor
having avg(cantidad * df.pre_unitario) < (select sum(df.pre_unitario * cantidad)
										  from detalle_facturas df)
--------------------------------------------------------------------------------------
--2. Liste los montos totales mensuales facturados por cliente y además del
--promedio de ese monto y el promedio de precio de artículos Todos esto
--datos correspondientes a período que va desde el 1° de febrero al 30 de
--agosto del 2014. Sólo muestre los datos si esos montos totales son
--superiores o iguales al promedio global.
--------------------------------------------------------------------------------------

select sum(cantidad * df.pre_unitario) 'Montos totales',
	   month(fecha) 'Mes',
	   avg(cantidad * df.pre_unitario) 'Montos Promedio',
	   avg(a.pre_unitario) 'Precio promedio x articulo'
from clientes c
	 join facturas f on f.cod_cliente = c.cod_cliente
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join articulos a on a.cod_articulo = df.cod_articulo
where fecha > 01/02/2006
group by month(fecha)
having sum(cantidad * df.pre_unitario) <= (select avg(cantidad * pre_unitario)
										   from detalle_facturas)
--------------------------------------------------------------------------------------
--3. Por cada artículo que se tiene a la venta, se quiere saber el importe
--promedio vendido, la cantidad total vendida por artículo, para los casos
--en que los números de factura no sean uno de los siguientes: 2, 10, 7, 13,
--22 y que ese importe promedio sea inferior al importe promedio de ese
--artículo.
--------------------------------------------------------------------------------------

select a.cod_articulo,
	   avg(cantidad * df.pre_unitario) 'Promedio venta',
	   sum(cantidad) 'cantidad total vendida'
from articulos a
	 join detalle_facturas df on df.cod_articulo = a.cod_articulo
where a.cod_articulo not in (2,10,7,13,22)
group by a.cod_articulo
having avg(cantidad * df.pre_unitario) < (select avg(a.pre_unitario)
										  from articulos a)
--------------------------------------------------------------------------------------
--4. Listar la cantidad total vendida, el importe y promedio vendido por fecha,
--siempre que esa cantidad sea superior al promedio de la cantidad global.
--Rotule y ordene.
--------------------------------------------------------------------------------------

select sum(cantidad) 'Cantidad total vendida',
	   sum(cantidad * pre_unitario) 'Importe total',
	   avg(cantidad * pre_unitario) 'Promedio',
	   fecha 'Fecha'
from facturas f 
	 join detalle_facturas df on df.nro_factura = f.nro_factura
group by fecha
having sum(cantidad) > (select avg(cantidad)
						from detalle_facturas)
--------------------------------------------------------------------------------------
--5. Se quiere saber el promedio del importe vendido y la fecha de la primer
--venta por fecha y artículo para los casos en que las cantidades vendidas
--oscilen entre 5 y 20 y que ese importe sea superior al importe promedio
--de ese artículo.
--------------------------------------------------------------------------------------

select avg(cantidad * df.pre_unitario) 'Promedio de Importe vendido',
	   min(fecha) 'Primera fecha',
	   a.descripcion 'Articulo',
	   count(df.nro_factura) 'Cantidad de ventas'
from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join articulos a on a.cod_articulo = df.cod_articulo
group by a.descripcion
having count(df.nro_factura) between 5 and 20
	   and avg(cantidad * df.pre_unitario) > (select avg(a.pre_unitario)
											  from articulos a)
--------------------------------------------------------------------------------------
--6. Emita un listado con los montos diarios facturados que sean inferior al
--importe promedio general.
--------------------------------------------------------------------------------------

select fecha 'Fecha',
	   sum(pre_unitario * cantidad) 'Monto diario'
from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
group by fecha
having sum(pre_unitario * cantidad) > (select avg(cantidad * pre_unitario)
									   from detalle_facturas)
--------------------------------------------------------------------------------------
--7. Se quiere saber la fecha de la primera y última venta, el importe total
--facturado por cliente para los años que oscilen entre el 2010 y 2015 y que
--el importe promedio facturado sea menor que el importe promedio total
--para ese cliente. 
--------------------------------------------------------------------------------------

select c.nom_cliente 'Cliente',
	   min(fecha) 'Primera venta',
	   max(fecha) 'Ultima venta',
	   sum(cantidad * df.pre_unitario) 'Importe total facturado'
from clientes c
	 join facturas f on f.cod_cliente = c.cod_cliente
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join articulos a on a.cod_articulo = df.cod_articulo
where year(fecha) between 2010 and 2015
group by c.nom_cliente
having avg(cantidad * df.pre_unitario) < (select avg(cantidad * df.pre_unitario)
										  from detalle_facturas df)

--------------------------------------------------------------------------------------
--8. Realice un informe que muestre cuánto fue el total anual facturado por
--cada vendedor, para los casos en que el nombre de vendedor no comience
--con ‘B’ ni con ‘M’, que los números de facturas oscilen entre 5 y 25 y que
--el promedio del monto facturado sea inferior al promedio de ese año.
--------------------------------------------------------------------------------------

select year(fecha) 'Año',
	   sum(cantidad * df.pre_unitario) 'Total Anual',
	   v.nom_vendedor + ', ' + v.ape_vendedor 'Vendedor'
from vendedores v
	 join facturas f on f.cod_vendedor = v.cod_vendedor
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join articulos a on a.cod_articulo = df.cod_articulo
where v.nom_vendedor not like '[b,m]%'
	  and df.nro_factura between 5 and 25
group by year(fecha),v.nom_vendedor + ', ' + v.ape_vendedor
having avg(cantidad * df.pre_unitario) < (select avg(cantidad * pre_unitario)
										  from detalle_facturas)
--------------------------------------------------------------------------------------
--EzeKe
--------------------------------------------------------------------------------------