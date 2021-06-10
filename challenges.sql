-- 3. Package pck_Helados

CREATE OR REPLACE PACKAGE pck_Helados is

    -- 3.1. Declaración de la Función fn_BuscarHelado
    var_id_helado number(10);
    function fn_BuscarHelado(var_codigo_helado varchar2) return NUMBER;
    -- end 3.1.
   
    -- 3.2 Declaración procedimiento prc_GenerarPedido
    procedure prc_GenerarPedido
    (var_pedido_id number, var_pedido_fecha date, var_estado varchar2, var_valor number, var_cliente_id number); 
    
        -- 3.2.1 Función que valida si el Cliente tiene algún pedido en estado Activo. 
        --       Se utiliza en el procedimiento prc_GenerarPedido a fin de validar el estado de los Pedidos anteriores del Cliente.
        var_cl number(10);
        function fn_EstadoPedido(var_cliente_id number) return NUMBER;
    -- end 3.2.1.
    
    -- end 3.2.
    
end pck_Helados;

CREATE OR REPLACE PACKAGE BODY pck_Helados is

    function fn_BuscarHelado(var_codigo_helado varchar2) return NUMBER
        is begin
        select
            helado_id into var_id_helado
        from Helado
        where helado_cd = var_codigo_helado;
        return var_id_helado;
    end fn_BuscarHelado;
    
    
    function fn_EstadoPedido(var_cliente_id number) return NUMBER
     is begin
        for i in ( select * from PEDIDO ) LOOP
            if(i.cliente_id = var_cliente_id) then
                if(i.estado = 'Activo') 
                 then
                    update PEDIDO 
                        set ESTADO = 'Cancelado'
                    where cliente_id = i.cliente_id;
                end if;
            end if;
        end LOOP;
        var_cl := var_cliente_id;
        return var_cl;
     end fn_EstadoPedido;
    

    procedure prc_GenerarPedido
    (var_pedido_id number, var_pedido_fecha date, var_estado varchar2, var_valor number, var_cliente_id number)
    is begin
        --prc_EstadoPedido(var_cliente_id);
        INSERT INTO PEDIDO (pedido_id, pedido_fecha, estado, valor, cliente_id) 
        values (var_pedido_id, var_pedido_fecha, var_estado, var_valor, fn_EstadoPedido(var_cliente_id));
    end prc_GenerarPedido;

end pck_Helados;
