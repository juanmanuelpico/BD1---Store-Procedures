-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb3 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`autoparte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`autoparte` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(200) NOT NULL,
  `precio` DOUBLE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`concesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`concesionaria` (
  `id` INT NOT NULL,
  `cuil` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`terminal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`terminal` (
  `id` INT NOT NULL,
  `cuil` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`linea_montaje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`linea_montaje` (
  `id` INT NOT NULL,
  `modelo` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(45) NOT NULL,
  `productividad_promedio_mensual` DOUBLE NULL DEFAULT NULL,
  `terminal_id` INT NOT NULL,
  PRIMARY KEY (`id`, `terminal_id`),
  INDEX `fk_linea_montaje_terminal1_idx` (`terminal_id` ASC) VISIBLE,
  CONSTRAINT `fk_linea_montaje_terminal1`
    FOREIGN KEY (`terminal_id`)
    REFERENCES `mydb`.`terminal` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`estacion_de_trabajo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`estacion_de_trabajo` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(300) NULL DEFAULT NULL,
  `ingresado` TINYINT(1) NULL DEFAULT NULL,
  `tarea_idtarea` INT NOT NULL,
  `linea_montaje_id` INT NOT NULL,
  `linea_montaje_terminal_id` INT NOT NULL,
  PRIMARY KEY (`id`, `tarea_idtarea`, `linea_montaje_id`, `linea_montaje_terminal_id`),
  INDEX `fk_estacion_de_trabajo_tarea1_idx` (`tarea_idtarea` ASC) VISIBLE,
  INDEX `fk_estacion_de_trabajo_linea_montaje1_idx` (`linea_montaje_id` ASC, `linea_montaje_terminal_id` ASC) VISIBLE,
  CONSTRAINT `fk_estacion_de_trabajo_linea_montaje1`
    FOREIGN KEY (`linea_montaje_id` , `linea_montaje_terminal_id`)
    REFERENCES `mydb`.`linea_montaje` (`id` , `terminal_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vehiculo` (
  `id` INT NOT NULL,
  `patente` VARCHAR(45) NOT NULL,
  `chasis` VARCHAR(45) NOT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  `marca` VARCHAR(45) NOT NULL,
  `modelo` VARCHAR(45) NOT NULL,
  `fabricacion` DATETIME NOT NULL,
  `finalizado` BIT(1) NOT NULL,
  `horas_produccion` FLOAT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`estacion_de_trabajo_has_vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`estacion_de_trabajo_has_vehiculo` (
  `estacion_de_trabajo_id` INT NOT NULL,
  `estacion_de_trabajo_tarea_idtarea` INT NOT NULL,
  `estacion_de_trabajo_linea_montaje_id` INT NOT NULL,
  `estacion_de_trabajo_linea_montaje_terminal_id` INT NOT NULL,
  `vehiculo_id` INT NOT NULL,
  `fecha_hora_ingreso` DATETIME NOT NULL,
  `fecha_hora_salida` DATETIME NULL DEFAULT NULL,
  `estacion_finalizada` BIT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`estacion_de_trabajo_id`, `estacion_de_trabajo_tarea_idtarea`, `estacion_de_trabajo_linea_montaje_id`, `estacion_de_trabajo_linea_montaje_terminal_id`, `vehiculo_id`),
  INDEX `fk_estacion_de_trabajo_has_vehiculo_vehiculo1_idx` (`vehiculo_id` ASC) VISIBLE,
  INDEX `fk_estacion_de_trabajo_has_vehiculo_estacion_de_trabajo1_idx` (`estacion_de_trabajo_id` ASC, `estacion_de_trabajo_tarea_idtarea` ASC, `estacion_de_trabajo_linea_montaje_id` ASC, `estacion_de_trabajo_linea_montaje_terminal_id` ASC) VISIBLE,
  CONSTRAINT `fk_estacion_de_trabajo_has_vehiculo_estacion_de_trabajo1`
    FOREIGN KEY (`estacion_de_trabajo_id` , `estacion_de_trabajo_tarea_idtarea` , `estacion_de_trabajo_linea_montaje_id` , `estacion_de_trabajo_linea_montaje_terminal_id`)
    REFERENCES `mydb`.`estacion_de_trabajo` (`id` , `tarea_idtarea` , `linea_montaje_id` , `linea_montaje_terminal_id`),
  CONSTRAINT `fk_estacion_de_trabajo_has_vehiculo_vehiculo1`
    FOREIGN KEY (`vehiculo_id`)
    REFERENCES `mydb`.`vehiculo` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pedido` (
  `id` INT NOT NULL,
  `marca` VARCHAR(45) NOT NULL,
  `modelo` VARCHAR(45) NOT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  `cantidad` INT NOT NULL,
  `fecha_entrega_estimada` DATETIME NULL DEFAULT NULL,
  `terminal_id` INT NOT NULL,
  `concesionaria_id` INT NOT NULL,
  `recibido` TINYINT NOT NULL,
  PRIMARY KEY (`id`, `terminal_id`, `concesionaria_id`),
  INDEX `fk_pedido_terminal1_idx` (`terminal_id` ASC) VISIBLE,
  INDEX `fk_pedido_concesionaria1_idx` (`concesionaria_id` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_concesionaria1`
    FOREIGN KEY (`concesionaria_id`)
    REFERENCES `mydb`.`concesionaria` (`id`),
  CONSTRAINT `fk_pedido_terminal1`
    FOREIGN KEY (`terminal_id`)
    REFERENCES `mydb`.`terminal` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`proveedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`proveedores` (
  `id` INT NOT NULL,
  `cuil` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`proveedores_has_autoparte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`proveedores_has_autoparte` (
  `proveedores_id` INT NOT NULL,
  `autoparte_id` INT NOT NULL,
  PRIMARY KEY (`proveedores_id`, `autoparte_id`),
  INDEX `fk_proveedores_has_autoparte_autoparte1_idx` (`autoparte_id` ASC) VISIBLE,
  INDEX `fk_proveedores_has_autoparte_proveedores1_idx` (`proveedores_id` ASC) VISIBLE,
  CONSTRAINT `fk_proveedores_has_autoparte_autoparte1`
    FOREIGN KEY (`autoparte_id`)
    REFERENCES `mydb`.`autoparte` (`id`),
  CONSTRAINT `fk_proveedores_has_autoparte_proveedores1`
    FOREIGN KEY (`proveedores_id`)
    REFERENCES `mydb`.`proveedores` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`remito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`remito` (
  `id` INT NOT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  `cantidad` INT NOT NULL,
  `total` DOUBLE NOT NULL,
  `fecha_hora` DATETIME NOT NULL,
  `origen` VARCHAR(45) NOT NULL,
  `destino` VARCHAR(45) NOT NULL,
  `terminal_id` INT NOT NULL,
  `autoparte_id` INT NOT NULL,
  PRIMARY KEY (`id`, `terminal_id`, `autoparte_id`),
  INDEX `fk_remito_terminal1_idx` (`terminal_id` ASC) VISIBLE,
  INDEX `fk_remito_autoparte1_idx` (`autoparte_id` ASC) VISIBLE,
  CONSTRAINT `fk_remito_autoparte1`
    FOREIGN KEY (`autoparte_id`)
    REFERENCES `mydb`.`autoparte` (`id`),
  CONSTRAINT `fk_remito_terminal1`
    FOREIGN KEY (`terminal_id`)
    REFERENCES `mydb`.`terminal` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`tarea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tarea` (
  `idtarea` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion_tarea` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idtarea`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`tarea_has_autoparte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tarea_has_autoparte` (
  `tarea_idtarea` INT NOT NULL,
  `autoparte_id` INT NOT NULL,
  `autoparte_proveedores_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`tarea_idtarea`, `autoparte_id`, `autoparte_proveedores_id`),
  INDEX `fk_tarea_has_autoparte_autoparte1_idx` (`autoparte_id` ASC, `autoparte_proveedores_id` ASC) VISIBLE,
  INDEX `fk_tarea_has_autoparte_tarea1_idx` (`tarea_idtarea` ASC) VISIBLE,
  CONSTRAINT `fk_tarea_has_autoparte_autoparte1`
    FOREIGN KEY (`autoparte_id`)
    REFERENCES `mydb`.`autoparte` (`id`),
  CONSTRAINT `fk_tarea_has_autoparte_tarea1`
    FOREIGN KEY (`tarea_idtarea`)
    REFERENCES `mydb`.`tarea` (`idtarea`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `mydb` ;

-- -----------------------------------------------------
-- procedure alta_autoparte
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `alta_autoparte`(
    IN id_autoparte INT,
    IN nombre_autoparte VARCHAR(45),
    IN descripcion_autoparte VARCHAR(45),
    IN precio_autoparte DOUBLE,
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE contador INT;
    
    -- Verificar si ya existe una autoparte con el mismo id o nombre
    SELECT COUNT(*) INTO contador FROM autoparte a WHERE a.id = id_autoparte OR a.nombre = nombre_autoparte;
    
    IF contador > 0 THEN
        SET mensaje = 'Ya existe una autoparte con el mismo ID o nombre.';
    ELSE
        -- Insertar la nueva autoparte
        INSERT INTO autoparte (id, nombre, descripcion, precio)
        VALUES (id_autoparte, nombre_autoparte, descripcion_autoparte, precio_autoparte);
        SET mensaje = '';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure alta_concesionaria
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `alta_concesionaria`(
    IN idConsecionaria INT,
    IN c_cuil VARCHAR(45),
    IN c_nombre VARCHAR(45),
    IN c_direccion VARCHAR(45),
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE contador INT;
    -- Verificar si ya existe un concesionario con el mismo id
    SELECT COUNT(*) INTO contador FROM concesionaria c WHERE c.id = idConsecionaria OR cuil = c_cuil;
    
    IF contador > 0 THEN
        SET mensaje = 'Ya existe un concesionario con el mismo ID o CUIL.';
    ELSE
        -- Insertar el nuevo concesionario
        INSERT INTO concesionaria (id, cuil, nombre, direccion)
        VALUES (idConsecionaria, c_cuil, c_nombre, c_direccion);
        
        SET mensaje = '';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure alta_estacion_de_trabajo
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `alta_estacion_de_trabajo`(in e_id int, in e_nombre varchar(45), in e_idTarea int, in e_idLinea int, in e_idLineaTerminal int,  in e_ingresado bool, out mensaje varchar(45))
begin
	declare contador int;
    select count(*) into contador from estacion_de_trabajo where id = e_id;
    
    if contador > 0 then
    set mensaje = 'ya existe una estacion de trabajo con el mismo id';
    else
		insert into estacion_de_trabajo (id, nombre, tarea_idTarea, linea_montaje_id, linea_montaje_terminal_id, ingresado)
        values (e_id, e_nombre, e_idTarea, e_idLinea, e_idLineaTerminal, ingresado);
        
        set mensaje = '';
	end if;
    
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure alta_pedido
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `alta_pedido`(
    IN p_id INT,
    IN p_marca VARCHAR(45),
    IN p_modelo VARCHAR(45),
    IN p_tipo VARCHAR(45),
    IN p_cantidad INT,
    IN p_fecha_entrega_estimada DATETIME,
    IN p_terminar_id INT,
    IN p_concesionaria_id INT,
    IN p_recibido tinyint,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    DECLARE contador INT;
    
    -- Verificar si ya existe un pedido con el mismo id
    SELECT COUNT(*) INTO contador FROM pedido WHERE id = p_id;
    
    IF contador > 0 THEN
        SET p_mensaje = 'Ya existe un pedido con el mismo ID.';
    ELSE
        -- Insertar el nuevo pedido
        INSERT INTO pedido (id, marca, modelo, tipo, cantidad, fecha_entrega_estimada, terminal_id, concesionaria_id, recibido)
        VALUES (p_id, p_marca, p_modelo, p_tipo, p_cantidad, p_fecha_entrega_estimada, p_terminar_id, p_concesionaria_id, p_recibido);
        
        SET p_mensaje = '';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure alta_tarea
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `alta_tarea`(in t_id int, in t_nombre varchar(45), in t_descripcion varchar(45), out mensaje varchar(45))
begin
	declare contador int;
    select count(*) into contador from tarea where idTarea = t_id;
    
    if contador > 0 then
    set mensaje = 'ya existe una tarea con el mismo id';
    else
		insert into tarea (idTarea, nombre, descripcion_tarea)
        values (t_id, t_nombre, t_descripcion);
        
        set mensaje = '';
	end if;
    
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure alta_terminal
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `alta_terminal`(
	IN id_terminal INT,
    IN t_cuil VARCHAR(45),
    IN t_nombre VARCHAR(45),
   IN t_direccion VARCHAR(45),
    OUT t_mensaje VARCHAR(255))
BEGIN
  
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure alta_vehiculos_por_pedido
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `alta_vehiculos_por_pedido`(
    IN id_pedido INT,
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_marca VARCHAR(45);
    DECLARE v_modelo VARCHAR(45);
    DECLARE v_tipo VARCHAR(45);
    DECLARE v_cantidad INT;
    DECLARE v_patente VARCHAR(45);
    DECLARE v_chasis VARCHAR(45);
    DECLARE v_fabricacion DATETIME;
    DECLARE v_finalizado BIT(1);
    DECLARE v_horas_produccion FLOAT;
    DECLARE i INT;
    DECLARE v_contador INT;
    
    -- Declarar el cursor
    DECLARE cur CURSOR FOR
        SELECT marca, modelo, tipo, cantidad FROM pedido p WHERE p.id = id_pedido and p.recibido = 0;
        
    -- Inicializar i
    SET i = 1;
	SET v_contador = 1;
    -- Abrir el cursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_marca, v_modelo, v_tipo, v_cantidad;
        -- Generar vehículos según el modelo y la cantidad
        WHILE i <= v_cantidad DO
        
			-- Obtener el valor del contador como el próximo ID
            SET @next_id = v_contador;
            
            -- Incrementar el contador para el próximo vehículo
            SET v_contador = v_contador + 1;
            -- Generar una patente aleatoria con el formato "AA-111-AA"
            SET v_patente = '';

            -- Intentar generar una patente única
            
            loop_patente: WHILE TRUE DO
                SET v_patente = CONCAT(
                    CHAR(FLOOR(65 + RAND() * 26)),
                    CHAR(FLOOR(65 + RAND() * 26)),
                    '-',
                    LPAD(FLOOR(RAND() * 1000), 3, '0'),
                    '-',
                    CHAR(FLOOR(65 + RAND() * 26)),
                    CHAR(FLOOR(65 + RAND() * 26))
                );

                -- Verificar si la patente ya existe en la tabla de vehículos
                SELECT COUNT(*) INTO @patente_count FROM vehiculo v WHERE v.patente = v_patente;

                IF @patente_count = 0 THEN
                    -- La patente es única, salir del bucle
                    LEAVE loop_patente;
                END IF;
            END WHILE loop_patente;
            
            -- Generar un chasis alfanumérico de 17 caracteres
            SET v_chasis = CONCAT(
                CHAR(FLOOR(65 + RAND() * 26)),
                CHAR(FLOOR(65 + RAND() * 26)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10))
            );

            -- Establecer la fecha de fabricación como la fecha actual
            SET v_fabricacion = NOW();

            -- Inicializar finalizado en FALSE
            SET v_finalizado = FALSE;

            -- Inicializar horas_produccion en 0
            SET v_horas_produccion = 0.0;

            -- Insertar el vehículo en la tabla de vehículos
            INSERT INTO vehiculo (id, patente, chasis, tipo, marca, modelo, fabricacion, finalizado, horas_produccion)
            VALUES (@next_id, v_patente, v_chasis, v_tipo, v_marca, v_modelo, v_fabricacion, v_finalizado, v_horas_produccion);
            
              -- insertar en relacion n a n entre vehiculo y estacion de trabajo
            select tarea_idTarea into @id_tarea from estacion_de_trabajo e where e.id = 1;
            select linea_montaje_id into @id_linea from estacion_de_trabajo e where e.id = 1;
            select linea_montaje_terminal_id into @id_terminal from estacion_de_trabajo e where e.id = 1;
            
            insert into estacion_de_trabajo_has_vehiculo (estacion_de_trabajo_id, estacion_de_trabajo_tarea_idtarea, estacion_de_trabajo_linea_montaje_id, estacion_de_trabajo_linea_montaje_terminal_id, vehiculo_id, fecha_hora_ingreso, fecha_hora_salida, estacion_finalizada)
            values (1, @id_tarea, @id_linea, @id_terminal, @next_id, now(), null, 0);
            
            -- end Juan ahre

            SET i = i + 1;
        END WHILE;
    END LOOP;

    -- Cerrar el cursor
    CLOSE cur;

    -- Finalizar el procedimiento
    SET mensaje = 'Vehículos generados exitosamente.';
    UPDATE pedido
    SET recibido = 1
	WHERE id = id_pedido;

    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure baja_concesionaria
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `baja_concesionaria`(
    IN idConcesionario INT,
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE contador INT;
    
    -- Verificar si el concesionario existe
    SELECT COUNT(*) INTO contador FROM concesionaria c WHERE c.id = idConcesionario;
    
    IF contador > 0 THEN
        -- Verificar si hay pedidos asociados al concesionario
        SELECT COUNT(*) INTO contador FROM pedido p WHERE p.concesionaria_id = idConcesionario;
        
        IF contador > 0 THEN
            SET mensaje = 'No se puede eliminar la concesionaria porque tiene pedidos asociados.';
        ELSE
            -- Eliminar el concesionario si no tiene pedidos asociados
            DELETE FROM concesionaria c WHERE c.id = idConcesionario;
            SET mensaje = 'Concesionaria eliminada exitosamente.';
        END IF;
    ELSE
        SET mensaje = 'No se encontró un concesionario con el ID especificado.';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure baja_pedido
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `baja_pedido`(
    IN p_id INT,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    -- Verificar si existe un pedido con el mismo id
    DECLARE contador INT;
    DECLARE fecha_entrega_estimada DATETIME;
    
    SELECT COUNT(*) INTO contador FROM pedido WHERE id = p_id;
    
    IF contador = 0 THEN
        SET p_mensaje = 'No existe un pedido con el ID especificado.';
    ELSE
        -- Obtener la fecha de entrega estimada del pedido
        SELECT fecha_entrega_estimada INTO fecha_entrega_estimada FROM pedido WHERE id = p_id;
        
        -- Verificar si la fecha de entrega estimada es NULL
        IF fecha_entrega_estimada IS NULL THEN
            -- Eliminar el pedido si la fecha de entrega estimada es NULL
            DELETE FROM pedido WHERE id = p_id;
            SET p_mensaje = 'Pedido dado de baja exitosamente.';
        ELSE
            SET p_mensaje = 'No se puede dar de baja el pedido con fecha de entrega estimada asignada.';
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure crear_linea_de_montaje
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_linea_de_montaje`(
	IN l_id INT,
    IN l_modelo VARCHAR(45),
    IN l_descripcion VARCHAR(45),
    IN l_productividad_promedio_mensual DOUBLE,
    IN l_terminal_id INT,
    OUT mensaje VARCHAR(255)
    
)
BEGIN
    
    DECLARE contador INT;
    
    -- Verificar si ya existe una autoparte con el mismo id o nombre
    SELECT COUNT(*) INTO contador FROM linea_montaje l WHERE l.id = l_id or l.modelo = l_modelo;
    
    IF contador > 0 THEN
        SET mensaje = 'Ya existe esta linea de montaje con el mismo ID o mismo modelo.';
    ELSE
        -- Insertar la nueva línea de montaje en la tabla
        INSERT INTO linea_montaje (id, modelo, descripcion, productividad_promedio_mensual, terminal_id)
        VALUES (l_id, l_modelo, l_descripcion, l_productividad_promedio_mensual, l_terminal_id);
        
        SET mensaje = 'Línea de montaje creada exitosamente.';
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure crear_vehiculos_por_pedido
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_vehiculos_por_pedido`(
    IN id_pedido INT,
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_marca VARCHAR(45);
    DECLARE v_modelo VARCHAR(45);
    DECLARE v_tipo VARCHAR(45);
    DECLARE v_cantidad INT;
    DECLARE v_patente VARCHAR(45);
    DECLARE v_chasis VARCHAR(45);
    DECLARE v_fabricacion DATETIME;
    DECLARE v_finalizado BIT(1);
    DECLARE v_horas_produccion FLOAT;
    DECLARE i INT;
    DECLARE v_contador INT;
    
    -- Declarar el cursor
    DECLARE cur CURSOR FOR
        SELECT marca, modelo, tipo, cantidad FROM pedido p WHERE p.id = id_pedido and p.recibido = 0;
        
    -- Inicializar i
    SET i = 1;
	SET v_contador = 1;
    -- Abrir el cursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_marca, v_modelo, v_tipo, v_cantidad;
        -- Generar vehículos según el modelo y la cantidad
        WHILE i <= v_cantidad DO
        
			-- Obtener el valor del contador como el próximo ID
            SET @next_id = v_contador;
            
            -- Incrementar el contador para el próximo vehículo
            SET v_contador = v_contador + 1;
            -- Generar una patente aleatoria con el formato "AA-111-AA"
            SET v_patente = '';

            -- Intentar generar una patente única
            
            loop_patente: WHILE TRUE DO
                SET v_patente = CONCAT(
                    CHAR(FLOOR(65 + RAND() * 26)),
                    CHAR(FLOOR(65 + RAND() * 26)),
                    '-',
                    LPAD(FLOOR(RAND() * 1000), 3, '0'),
                    '-',
                    CHAR(FLOOR(65 + RAND() * 26)),
                    CHAR(FLOOR(65 + RAND() * 26))
                );

                -- Verificar si la patente ya existe en la tabla de vehículos
                SELECT COUNT(*) INTO @patente_count FROM vehiculo v WHERE v.patente = v_patente;

                IF @patente_count = 0 THEN
                    -- La patente es única, salir del bucle
                    LEAVE loop_patente;
                END IF;
            END WHILE loop_patente;
            
            -- Generar un chasis alfanumérico de 17 caracteres
            SET v_chasis = CONCAT(
                CHAR(FLOOR(65 + RAND() * 26)),
                CHAR(FLOOR(65 + RAND() * 26)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10)),
                CHAR(FLOOR(48 + RAND() * 10))
            );

            -- Establecer la fecha de fabricación como la fecha actual
            SET v_fabricacion = NOW();

            -- Inicializar finalizado en FALSE
            SET v_finalizado = FALSE;

            -- Inicializar horas_produccion en 0
            SET v_horas_produccion = 0.0;

            -- Insertar el vehículo en la tabla de vehículos
            INSERT INTO vehiculo (id, patente, chasis, tipo, marca, modelo, fabricacion, finalizado, horas_produccion)
            VALUES (@next_id, v_patente, v_chasis, v_tipo, v_marca, v_modelo, v_fabricacion, v_finalizado, v_horas_produccion);
            
              -- insertar en relacion n a n entre vehiculo y estacion de trabajo
            select tarea_idTarea into @id_tarea from estacion_de_trabajo e where e.id = 1;
            select linea_montaje_id into @id_linea from estacion_de_trabajo e where e.id = 1;
            select linea_montaje_terminal_id into @id_terminal from estacion_de_trabajo e where e.id = 1;
            
            insert into estacion_de_trabajo_has_vehiculo (estacion_de_trabajo_id, estacion_de_trabajo_tarea_idtarea, estacion_de_trabajo_linea_montaje_id, estacion_de_trabajo_linea_montaje_terminal_id, vehiculo_id, fecha_hora_ingreso, fecha_hora_salida)
            values (1, @id_tarea, @id_linea, @id_terminal, @next_id, now(), now() );
            
            -- end Juan ahre

            SET i = i + 1;
        END WHILE;
    END LOOP;

    -- Cerrar el cursor
    CLOSE cur;

    -- Finalizar el procedimiento
    SET mensaje = 'Vehículos generados exitosamente.';
    UPDATE pedido
    SET recibido = 1
	WHERE id = id_pedido;

    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminar_autoparte
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_autoparte`(
    IN id_autoparte INT,
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE contador INT;
    
    -- Verificar si la autoparte existe
    SELECT COUNT(*) INTO contador FROM autoparte a WHERE a.id = id_autoparte;
    
    IF contador > 0 THEN
        -- Eliminar la autoparte por ID
        DELETE FROM autoparte a WHERE a.id = id_autoparte;
        SET mensaje = 'Autoparte eliminada exitosamente.';
    ELSE
        SET mensaje = 'No se encontró una autoparte con el ID especificado.';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inicio_vehiculo_montaje
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `inicio_vehiculo_montaje`(in patente varchar(45), out mensaje varchar(255))
BEGIN
		
		/*declaramos las variables*/
        declare id_estacion int;
        declare estacion_libre BIT(1);
        declare id_vehiculo INT;
        /*La estacion con id 2 representa la primer estacion de labor */
		set id_estacion = 2;
        select ingresado into estacion_libre from estacion_de_trabajo e where e.id = id_estacion;/*obtenemos el valor si hay un vehiculo ingresado en la estacion*/
        /*si no hay un vehiculo ingresado entonces accedemos*/
       if(estacion_libre = 0) then
       
			select id into id_vehiculo from vehiculo v where lower(v.patente) = LOWER(patente) limit 1; /*obtenemos el id del auto con dicha patente*/
            select id_vehiculo;
            /*Una vez obtenido el id del vehiculo, nos interesa sacar al vehiculo de su estacion actual y mandarlo a la que le sigue*/
            /*Por lo tanto debemos setear la fecha de finalizacion y estacion_finalizada en la tabla intermedia*/
            
            update estacion_de_trabajo_has_vehiculo
            set fecha_hora_salida = now(),
                estacion_finalizada = 1
            where estacion_de_trabajo_id = 1 and vehiculo_id = id_vehiculo;    
            
            /*y luego debemos crear un nuevo registro a la tabla intermedia */
            select tarea_idTarea into @id_tarea from estacion_de_trabajo e where e.id = id_estacion;
            select linea_montaje_id into @id_linea from estacion_de_trabajo e where e.id = id_estacion;
            select linea_montaje_terminal_id into @id_terminal from estacion_de_trabajo e where e.id = id_estacion;
            
			insert into estacion_de_trabajo_has_vehiculo (estacion_de_trabajo_id, estacion_de_trabajo_tarea_idtarea, estacion_de_trabajo_linea_montaje_id, estacion_de_trabajo_linea_montaje_terminal_id, vehiculo_id, fecha_hora_ingreso, fecha_hora_salida, estacion_finalizada)
            values (id_estacion, @id_tarea, @id_linea, @id_terminal, id_vehiculo, now(), null, 0);
            /*Por ultimo, seteamos el valor "ingresado" de la estacion, para indicar que la estacion esta ocupada*/
			update estacion_de_trabajo
            set ingresado = 1
            where id = id_estacion;    
			set mensaje = 'Estacion de trabajo asignada correctamente';
            
       else
       
			set mensaje = 'La estacion de trabajo esta ocupada por otro vehiculo';
            
       end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificar_autoparte
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modificar_autoparte`(
    IN id_autoparte INT,
    IN nuevo_nombreAutoparte VARCHAR(45),
    IN nueva_descripcionAutoparte VARCHAR(200),
    IN nuevo_precioAutoparte DOUBLE,
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE contador INT;
    
    -- Verificar si la autoparte existe
    SELECT COUNT(*) INTO contador FROM autoparte a WHERE a.id = id_autoparte;
    
    IF contador > 0 THEN
        -- Realizar la actualización excluyendo id
        UPDATE autoparte
        SET nombre = nuevo_nombreAutoparte,
            descripcion = nueva_descripcionAutoparte,
            precio = nuevo_precioAutoparte
        WHERE id = id_autoparte;
        
        SET mensaje = 'Autoparte modificada exitosamente.';
    ELSE
        SET mensaje = 'No se encontró una autoparte con el ID especificado.';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificar_concesionaria
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modificar_concesionaria`(
    IN idConcesionario INT,
    IN nuevo_nombre VARCHAR(45),
    IN nueva_direccion VARCHAR(45),
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE contador INT;
    
    -- Verificar si el concesionario existe
    SELECT COUNT(*) INTO contador FROM concesionaria WHERE id = idConcesionario;
    
    IF contador > 0 THEN
        -- Realizar la actualización excluyendo id y cuil
        UPDATE concesionaria
        SET nombre = nuevo_nombre, direccion = nueva_direccion
        WHERE id = idConcesionario;
        
        SET mensaje = 'Concesionario modificado exitosamente.';
    ELSE
        SET mensaje = 'No se encontró un concesionario con el ID especificado.';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificar_pedido
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modificar_pedido`(
    IN p_id INT,
    IN p_marca VARCHAR(45),
    IN p_modelo VARCHAR(45),
    IN p_tipo VARCHAR(45),
    IN p_cantidad INT,
    IN p_fecha_entrega_estimada DATETIME,
    IN p_terminar_id INT,
    IN p_concesionaria_id INT,
    OUT p_mensaje VARCHAR(255)
)
BEGIN
    -- Verificar si existe un pedido con el mismo id
    DECLARE contador INT;
    DECLARE fecha_entrega_estimada DATETIME;
    
    SELECT COUNT(*) INTO contador FROM pedido WHERE id = p_id;
    
    IF contador = 0 THEN
        SET p_mensaje = 'No existe un pedido con el ID especificado.';
    ELSE
        -- Obtener la fecha de entrega estimada del pedido
        SELECT fecha_entrega_estimada INTO fecha_entrega_estimada FROM pedido WHERE id = p_id;
        
        -- Verificar si la fecha de entrega estimada es NULL
        IF fecha_entrega_estimada IS NULL THEN
            -- Realizar la actualización si la fecha de entrega estimada es NULL
            UPDATE pedido
            SET marca = p_marca,
                modelo = p_modelo,
                tipo = p_tipo,
                cantidad = p_cantidad,
                fecha_entrega_estimada = p_fecha_entrega_estimada,
                terminal_id = p_terminar_id,
                concesionaria_id = p_concesionaria_id
            WHERE id = p_id;
            
            SET p_mensaje = 'Pedido modificado exitosamente.';
        ELSE
            SET p_mensaje = 'No se puede modificar el pedido con fecha de entrega estimada asignada.';
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mover_vehiculo_a_siguiente_estacion_de_trabajo
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mover_vehiculo_a_siguiente_estacion_de_trabajo`(IN patente VARCHAR(45), OUT mensaje VARCHAR(255))
BEGIN
    DECLARE id_estacion_actual INT;
    DECLARE id_estacion_siguiente INT;
    DECLARE estacion_libre BIT(1);
    DECLARE id_vehiculo INT;
    DECLARE total_estaciones INT;
    DECLARE diferencia_horas FLOAT;
    DECLARE fecha_inicio DATETIME;
    DECLARE fecha_fin DATETIME;
    
    SELECT COUNT(*) INTO total_estaciones FROM estacion_de_trabajo;
    
    SELECT id INTO id_vehiculo FROM vehiculo v WHERE LOWER(v.patente) = LOWER(patente) LIMIT 1;
    
    SELECT estacion_de_trabajo_id INTO id_estacion_actual FROM estacion_de_trabajo_has_vehiculo etv WHERE etv.vehiculo_id = id_vehiculo AND etv.estacion_finalizada = 0;
    
    SET id_estacion_siguiente = id_estacion_actual + 1;
    
    IF (id_estacion_siguiente <= total_estaciones) THEN
        SELECT ingresado INTO estacion_libre FROM estacion_de_trabajo e WHERE e.id = id_estacion_siguiente;
        IF (estacion_libre = 0) THEN
            UPDATE estacion_de_trabajo_has_vehiculo
            SET fecha_hora_salida = NOW(),
                estacion_finalizada = 1
            WHERE estacion_de_trabajo_id = id_estacion_actual AND vehiculo_id = id_vehiculo;
            
            SELECT tarea_idTarea INTO @id_tarea FROM estacion_de_trabajo e WHERE e.id = id_estacion_siguiente;
            SELECT linea_montaje_id INTO @id_linea FROM estacion_de_trabajo e WHERE e.id = id_estacion_siguiente;
            SELECT linea_montaje_terminal_id INTO @id_terminal FROM estacion_de_trabajo e WHERE e.id = id_estacion_siguiente;
            
            INSERT INTO estacion_de_trabajo_has_vehiculo (estacion_de_trabajo_id, estacion_de_trabajo_tarea_idtarea, estacion_de_trabajo_linea_montaje_id, estacion_de_trabajo_linea_montaje_terminal_id, vehiculo_id, fecha_hora_ingreso, fecha_hora_salida, estacion_finalizada)
            VALUES (id_estacion_siguiente, @id_tarea, @id_linea, @id_terminal, id_vehiculo, NOW(), NULL, 0);
            
            UPDATE estacion_de_trabajo
            SET ingresado = 1
            WHERE id = id_estacion_siguiente;
            /*liberamos la estacion de trabajo anterior*/
			UPDATE estacion_de_trabajo
            SET ingresado = 0
            WHERE id = id_estacion_actual;
            SET mensaje = 'SE MOVIO EL VEHICULO A LA SIGUIENTE ESTACION';
            
            If(id_estacion_siguiente = total_estaciones) then
             /*guardamos la primer y ultima fecha de produccion*/
                 SELECT fecha_hora_ingreso INTO fecha_inicio FROM estacion_de_trabajo_has_vehiculo ev WHERE ev.estacion_de_trabajo_id = 1 and ev.vehiculo_id = id_vehiculo;
				 SELECT fecha_hora_salida INTO fecha_fin FROM estacion_de_trabajo_has_vehiculo ev WHERE ev.estacion_de_trabajo_id = id_estacion_siguiente and ev.vehiculo_id = id_vehiculo;
               -- Calculas la diferencia en horas y la almacenas en la variable
                SELECT TIMESTAMPDIFF(HOUR, fecha_inicio, fecha_fin) INTO diferencia_horas;
            /*Si la estacion es la ultima, damos al vehiculo por finalizado*/
            
				UPDATE vehiculo
                SET finalizado = 1,
                horas_produccion = diferencia_horas
                WHERE id = id_vehiculo;
			
               /*Luego liberamos la ultima estacion*/
				UPDATE estacion_de_trabajo
                SET ingresado = 0
                WHERE id = id_estacion_siguiente;
                
                 SET mensaje = 'El vehiculo ha finalizado su produccio :)';
                 
            end if;
        ELSE
            SET mensaje = 'La estacion de trabajo está ocupada por otro vehículo';
        END IF;
    END IF;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
