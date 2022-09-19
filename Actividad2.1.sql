----------------------------------------------------------------------------------
--                                                                              --
--                                Problema 2.1                                  --
--                                                                              --
----------------------------------------------------------------------------------

--1. Se solicita un listado de artículos cuyo precio es inferior al promedio de
--precios de todos los artículos. (está resuelto en el material teórico)
----------------------------------------------------------------------------------

select cod_articulo 'Articulos', descripcion, pre_unitario
from articulos
where pre_unitario<(select avg(pre_unitario) from articulos)

----------------------------------------------------------------------------------
--2. Emitir un listado de los artículos que no fueron vendidos este año. En ese
--listado solo incluir aquellos cuyo precio unitario del artículo oscile entre
--50 y 100.
----------------------------------------------------------------------------------

--select distinct df.cod_articulo, a.descripcion
--from detalle_facturas df
--	 join articulos a on a.cod_articulo = df.cod_articulo --PARA VERIFICAR SI LO DE ABAJO ESTA BIEN
--	 join facturas f on f.nro_factura = df.nro_factura
--WHERE YEAR(fecha) = YEAR(GETDATE())
--order by 1

select a.cod_articulo 'Codigo de Articulo', a.descripcion 'Articulo', a.pre_unitario 'Precio Articulo'
from articulos a 
where a.cod_articulo not in (select df.cod_articulo from detalle_facturas df join facturas f on f.nro_factura = df.nro_factura WHERE YEAR(fecha) = YEAR(GETDATE()))
----------------------------------------------------------------------------------
--3. Genere un reporte con los clientes que vinieron más de 10 veces el año
--pasado.
----------------------------------------------------------------------------------
						--ver cuantas veces vinieron 
----------------------------------------------------------------------------------

select distinct c.nom_cliente + ', ' + c.ape_cliente 'Cliente',
	   count(f.cod_cliente)
from clientes c
	 join facturas f on f.cod_cliente = c.cod_cliente
where c.cod_cliente in (select f.cod_cliente
					  from facturas f
					  where year(fecha)=year(getdate())-1
					  group by f.cod_cliente
					  having count(f.cod_cliente) > 10)
group by c.nom_cliente + ', ' + c.ape_cliente
----------------------------------------------------------------------------------
--						no ver cuantuantas veces vinieron
----------------------------------------------------------------------------------

select distinct c.nom_cliente + ', ' + c.ape_cliente 'Cliente'
from clientes c
where c.cod_cliente in (select f.cod_cliente
					  from facturas f
					  where year(fecha)=year(getdate())-1
					  group by f.cod_cliente
					  having count(f.cod_cliente) > 10)

----------------------------------------------------------------------------------
--4. Se quiere saber qué clientes no vinieron entre el 12/12/2015 y el 13/7/2020
----------------------------------------------------------------------------------

--no salia ninguno no se por q
select cod_cliente 'Codigo', 
	   ape_cliente + ', '+ nom_cliente 'Cliente'
from clientes c
where cod_cliente not in (select cod_cliente
						  from facturas
						  where fecha > 12/12/2015)
----------------------------------------------------------------------------------
--5. Listar los datos de las facturas de los clientes que solo vienen a comprar
--en febrero es decir que todas las veces que vienen a comprar haya sido
--en el mes de febrero (y no otro mes).
----------------------------------------------------------------------------------

select cod_cliente 'Codigo', 
	   ape_cliente + ', '+ nom_cliente 'Cliente'
from clientes c
where cod_cliente in (select cod_cliente
						  from facturas
						  where month(fecha) = 2
						  )

----------------------------------------------------------------------------------
--6. Mostrar los datos de las facturas para los casos en que por año se hayan
--hecho menos de 9 facturas. 
----------------------------------------------------------------------------------

--select year(fecha), 
--	   count(nro_factura) 
--from facturas 
--group by year(fecha)
--having count(nro_factura) < 9

select count(df.nro_factura), YEAR(fecha) 
from facturas F
JOIN detalle_facturas DF on df.nro_factura = f.nro_factura
group by year(fecha)
having count(df.nro_factura) < 9 



----------------------------------------------------------------------------------
--7. Emitir un reporte con las facturas cuyo importe total haya sido superior a
--1.500 (incluir en el reporte los datos de los artículos vendidos y los
--importes).
----------------------------------------------------------------------------------

select f.nro_factura 'Factura',
	   a.descripcion 'Articulos',
	   sum(cantidad * df.pre_unitario) 'Precio total'
from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join articulos a on a.cod_articulo = df.cod_articulo
group by f.nro_factura,a.descripcion
having sum(cantidad * df.pre_unitario) > 10000 

select f.nro_factura,	
	   descripcion 'Articulo', 
	   sum(cantidad * df.pre_unitario) 'Precio total'
from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join articulos a on a.cod_articulo = df.cod_articulo




select cod_cliente, ape_cliente, nom_cliente
from clientes
where cod_cliente in (select cod_cliente
from facturas
where YEAR(fecha)=YEAR(GETDATE())
)

----------------------------------------------------------------------------------
--8. Se quiere saber qué vendedores nunca atendieron a estos clientes: 1 y 6.
--Muestre solamente el nombre del vendedor.
----------------------------------------------------------------------------------

select nom_vendedor
from vendedores
where cod_vendedor in (select f.cod_vendedor	
					   from facturas f
					   where f.cod_cliente not in (1,6)
					   )

----------------------------------------------------------------------------------
--9. Listar los datos de los artículos que superaron el promedio del Importe de
--ventas de $ 1.000.
----------------------------------------------------------------------------------




----------------------------------------------------------------------------------
--10. ¿Qué artículos nunca se vendieron? Tenga además en cuenta que su
--nombre comience con letras que van de la “d” a la “p”. Muestre solamente
--la descripción del artículo.
----------------------------------------------------------------------------------

select a.cod_articulo,a.descripcion
from articulos a
where a.cod_articulo not in (select df.cod_articulo
							 from detalle_facturas df 
							 )
							 and a.descripcion  like '[d-p]%'

----------------------------------------------------------------------------------
--11. Listar número de factura, fecha y cliente para los casos en que ese cliente
--haya sido atendido alguna vez por el vendedor de código 3.
----------------------------------------------------------------------------------

select nro_factura,
	   fecha, 
	   c.nom_cliente + ', '+ c.ape_cliente 'Cliente',
	   cod_vendedor
from facturas f
	 join clientes c on c.cod_cliente = f.cod_cliente
where 3 = all (select cod_vendedor
			   from facturas f
			   where c.cod_cliente = f.cod_cliente)
----------------------------------------------------------------------------------
--12. Listar número de factura, fecha, artículo, cantidad e importe para los
--casos en que todas las cantidades (de unidades vendidas de cada
--artículo) de esa factura sean superiores a 40.
----------------------------------------------------------------------------------

select f.nro_factura 'Numero factura', 
	   fecha 'Fecha',
	   a.descripcion 'Articulos',
	   df.cantidad 'Cantidad',
	   sum(df.pre_unitario * cantidad) 'Importe'
from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join articulos a on a.cod_articulo =df.cod_articulo
where 40 < all (select df.cantidad
			from detalle_facturas df
			where df.nro_factura = f.nro_factura)
group by f.nro_factura, fecha, descripcion, cantidad
----------------------------------------------------------------------------------
--13. Emitir un listado que muestre número de factura, fecha, artículo, cantidad
--e importe; para los casos en que la cantidad total de unidades vendidas
--sean superior a 80.
----------------------------------------------------------------------------------

select f.nro_factura 'Numero factura', 
	   fecha 'Fecha',
	   a.descripcion 'Articulos',
	   df.cantidad 'Cantidad',
	   sum(df.pre_unitario * cantidad) 'Importe'
from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join articulos a on a.cod_articulo =df.cod_articulo
where 80 < all (select df.cantidad
			from detalle_facturas df
			where df.nro_factura = f.nro_factura)
group by f.nro_factura, fecha, descripcion, cantidad
----------------------------------------------------------------------------------
--14. Realizar un listado de número de factura, fecha, cliente, artículo e importe
--para los casos en que al menos uno de los importes de esa factura sea
--menor a 3.000.
----------------------------------------------------------------------------------

select f.nro_factura 'Numero factura', 
	   fecha 'Fecha',
	   a.descripcion 'Articulos',
	   df.cantidad 'Cantidad',
	   sum(df.pre_unitario * cantidad) 'Importe'
from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
	 join articulos a on a.cod_articulo =df.cod_articulo
where 500> (select sum(df.pre_unitario * cantidad)
				 from detalle_facturas df
				 where df.nro_factura = f.nro_factura)
group by f.nro_factura, fecha, descripcion, cantidad
----------------------------------------------------------------------------------
