--2. Se quiere saber qué vendedores y clientes hay en la empresa; para los casos en
--que su teléfono y dirección de e-mail sean conocidos. Se deberá visualizar el
--código, nombre y si se trata de un cliente o de un vendedor. Ordene por la
--columna tercera y segunda.

select cod_cliente Codigo, ape_cliente + ', ' + nom_cliente Nombre, 'Cliente' Tipo
from clientes
union
select cod_vendedor Codigo, ape_vendedor + ', ' + nom_vendedor Nombre, 'Vendedor' Tipo
from vendedores
order by 3, 2

--------------------------------------O PUEDE SER--------------------------------------

select cod_cliente Codigo, ape_cliente + ', ' + nom_cliente Nombre, 'Cliente' Tipo
from clientes
where nro_tel is not null and [e-mail] is not null
union
select cod_vendedor Codigo, ape_vendedor + ', ' + nom_vendedor Nombre, 'Vendedor' Tipo
from vendedores
where nro_tel is not null and [e-mail] is not null
order by 3, 2

---------------------------------------------------------------------------------------

--3. Emitir un listado donde se muestren qué artículos, clientes y vendedores hay en
--la empresa. Determine los campos a mostrar y su ordenamiento.

select cod_cliente Codigo, ape_cliente + ', ' + nom_cliente Nombre, 'Cliente' Tipo
from clientes
union
select cod_vendedor Codigo, ape_vendedor + ', ' + nom_vendedor Nombre, 'Vendedor' Tipo
from vendedores
union
select cod_articulo Codigo, descripcion Nombre, 'Articulo' Tipo
from articulos
order by 1, 2

---------------------------------------------------------------------------------------

--4. Se quiere saber las direcciones (incluido el barrio) tanto de clientes como de
--vendedores. Para el caso de los vendedores, códigos entre 3 y 12. En ambos
--casos las direcciones deberán ser conocidas. Rotule como NOMBRE,
--DIRECCION, BARRIO, INTEGRANTE (en donde indicará si es cliente o vendedor).
--Ordenado por la primera y la última columna.

select cod_cliente Codigo, ape_cliente + ', ' + nom_cliente Nombre, calle + SPACE(1)+LTRIM(str(altura)) 'Direccion', b.barrio Barrio, 'Cliente' Integrante
from clientes c join
	 barrios b on b.cod_barrio = c.cod_barrio
where 'Direccion' is not null and b.barrio is not null
union
select cod_vendedor Codigo, ape_vendedor + ', ' + nom_vendedor Nombre,calle + SPACE(1)+ LTRIM(str(altura)) 'Direccion', b2.barrio Barrio, 'Vendedor' Integrante
from vendedores v join 
	 barrios b2 on b2.cod_barrio = v.cod_barrio
where cod_vendedor between 3 and 12 and 'Direccion' is not null and b2.barrio is not null
order by 1, 4

-----------------------------------------------------------------------------------------

--5. Ídem al ejercicio anterior, sólo que además del código, identifique de donde
--obtiene la información (de qué tabla se obtienen los datos).

select cod_cliente Codigo, 'Tabla Cliente' Informacion ,ape_cliente + ', ' + nom_cliente Nombre, calle + SPACE(1)+LTRIM(str(altura)) 'Direccion', b.barrio Barrio, 'Cliente' Integrante
from clientes c join
	 barrios b on b.cod_barrio = c.cod_barrio
where 'Direccion' is not null and b.barrio is not null
union
select cod_vendedor Codigo,'Tabla Vendedor' Informacion,ape_vendedor + ', ' + nom_vendedor Nombre,calle + SPACE(1)+ LTRIM(str(altura)) 'Direccion', b2.barrio Barrio, 'Vendedor' Integrante
from vendedores v join 
	 barrios b2 on b2.cod_barrio = v.cod_barrio
where cod_vendedor between 3 and 12 and 'Direccion' is not null and b2.barrio is not null
order by 1, 4

-----------------------------------------------------------------------------------------

--6. Listar todos los artículos que están a la venta cuyo precio unitario oscile entre 10
--y 50; también se quieren listar los artículos que fueron comprados por los
--clientes cuyos apellidos comiencen con “M” o con “P”.

--PUEDE QUE ESTE MAL JE
select descripcion Articulo, a.pre_unitario Precio, c.nom_cliente + ', ' + c.ape_cliente Cliente
from articulos a 
	 join detalle_facturas df on a.cod_articulo = df.cod_articulo
	 join facturas f on f.nro_factura = df.nro_factura
	 join clientes c on c.cod_cliente = f.cod_cliente
where c.nom_cliente like '[M,P]%' or a.pre_unitario between 100 and 150

---------------------------------------PRUEBA-------------------------------------------

select descripcion Articulo, a.pre_unitario Precio, c.nom_cliente + ', ' + c.ape_cliente Cliente, 'M-P' Tipo
from articulos a 
	 join detalle_facturas df on a.cod_articulo = df.cod_articulo
	 join facturas f on f.nro_factura = df.nro_factura
	 join clientes c on c.cod_cliente = f.cod_cliente
where c.nom_cliente like '[M,P]%'
UNION
select descripcion Articulo, a.pre_unitario Precio, c.nom_cliente + ', ' + c.ape_cliente Cliente, '100-150' Tipo
from articulos a 
	 join detalle_facturas df on a.cod_articulo = df.cod_articulo
	 join facturas f on f.nro_factura = df.nro_factura
	 join clientes c on c.cod_cliente = f.cod_cliente
WHERE a.pre_unitario between 100 and 150



-----------------------------------------------------------------------------------------
--7. El encargado del negocio quiere saber cuánto fue la facturación del año pasado.
--Por otro lado, cuánto es la facturación del mes pasado, la de este mes y la de
--hoy (Cada pedido en una consulta distinta, y puede unirla en una sola tabla de
--resultado)

select convert(char,f.fecha,103) Fecha , sum(df.pre_unitario * df.cantidad) Precio
from facturas f
	 join detalle_facturas df on df.nro_factura = f.nro_factura
where YEAR(fecha) = YEAR(GETDATE())-1 or 
	  YEAR(fecha) = YEAR(GETDATE()) and MONTH(fecha) = MONTH(GETDATE())-1 or
	  YEAR(fecha) = YEAR(GETDATE()) and MONTH(fecha) = MONTH(GETDATE()) or
	  YEAR(fecha) = YEAR(GETDATE()) and day(fecha) = day(GETDATE()) 
group by fecha

-----------------------------------------------------------------------------------------
--                                    Ezek                                             --
-----------------------------------------------------------------------------------------
