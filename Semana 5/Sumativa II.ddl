-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2026-02-05 21:17:22 CLST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE Boleta 
    ( 
     Num_Boleta         NUMBER (5)  NOT NULL , 
     Fecha              DATE  NOT NULL , 
     Monto_Total        NUMBER (12)  NOT NULL , 
     Cliente_Id_Cliente NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE Boleta 
    ADD CONSTRAINT Boleta_PK PRIMARY KEY ( Num_Boleta ) ;

CREATE TABLE Cliente 
    ( 
     Id_Cliente       NUMBER (4)  NOT NULL , 
     Nombres          VARCHAR2 (50)  NOT NULL , 
     Apellidos        VARCHAR2 (50)  NOT NULL , 
     Telefono         VARCHAR2 (15)  NOT NULL , 
     Comuna_Id_Comuna NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE Cliente 
    ADD CONSTRAINT Cliente_PK PRIMARY KEY ( Id_Cliente ) ;

CREATE TABLE Comuna 
    ( 
     Id_Comuna        NUMBER (4)  NOT NULL , 
     Nombre_Comuna    VARCHAR2 (25)  NOT NULL , 
     Region_Id_Region NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE Comuna 
    ADD CONSTRAINT Comuna_PK PRIMARY KEY ( Id_Comuna ) ;

CREATE TABLE Detalle_Boleta 
    ( 
     Producto_Id_Producto    NUMBER (4)  NOT NULL , 
     Producto_Sigla_Sucursal VARCHAR2 (10)  NOT NULL , 
     Boleta_Num_Boleta       NUMBER (5)  NOT NULL , 
     Cantidad                NUMBER (4)  NOT NULL , 
     Monto_Parcial           NUMBER (12)  NOT NULL 
    ) 
;

ALTER TABLE Detalle_Boleta 
    ADD CONSTRAINT Detalle_Boleta_PK PRIMARY KEY ( Producto_Id_Producto, Producto_Sigla_Sucursal, Boleta_Num_Boleta ) ;

CREATE TABLE Marca 
    ( 
     Id_Marca     NUMBER (4)  NOT NULL , 
     Nombre_Marca VARCHAR2 (25)  NOT NULL 
    ) 
;

ALTER TABLE Marca 
    ADD CONSTRAINT Marca_PK PRIMARY KEY ( Id_Marca ) ;

CREATE TABLE Modelo 
    ( 
     Id_Modelo          NUMBER (4)  NOT NULL , 
     Descripcion_Modelo VARCHAR2 (500) , 
     Marca_Id_Marca     NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE Modelo 
    ADD CONSTRAINT Modelo_PK PRIMARY KEY ( Id_Modelo, Marca_Id_Marca ) ;

CREATE TABLE Producto 
    ( 
     Id_Producto             NUMBER (4)  NOT NULL , 
     Nombre_Producto         VARCHAR2 (150)  NOT NULL , 
     Descripcion             VARCHAR2 (500) , 
     Fecha_Vencimiento       DATE , 
     Precio                  NUMBER (10) , 
     Modelo_Id_Modelo        NUMBER (4)  NOT NULL , 
     Modelo_Marca_Id_Marca   NUMBER (4)  NOT NULL , 
     Proveedor_Rut           NUMBER (9)  NOT NULL , 
     Sucursal_Sigla_Sucursal VARCHAR2 (10)  NOT NULL 
    ) 
;

ALTER TABLE Producto 
    ADD CONSTRAINT Producto_PK PRIMARY KEY ( Id_Producto, Sucursal_Sigla_Sucursal ) ;

CREATE TABLE Proveedor 
    ( 
     Rut              NUMBER (9)  NOT NULL , 
     Dv               CHAR (1)  NOT NULL , 
     Tipo_Proveedor   CHAR (1)  NOT NULL , 
     Fono             VARCHAR2 (15)  NOT NULL , 
     Email            VARCHAR2 (50)  NOT NULL , 
     Nombre_Calle     VARCHAR2 (25)  NOT NULL , 
     Num_Calle        NUMBER (5)  NOT NULL , 
     "Block/Dpto"     VARCHAR2 (10) , 
     Comuna_Id_Comuna NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE Proveedor 
    ADD CONSTRAINT Proveedor_PK PRIMARY KEY ( Rut ) ;

CREATE TABLE Proveedor_Empresa 
    ( 
     Rut          NUMBER (9)  NOT NULL , 
     Razon_Social VARCHAR2 (50)  NOT NULL , 
     Sitio_Web    VARCHAR2 (150) 
    ) 
;

ALTER TABLE Proveedor_Empresa 
    ADD CONSTRAINT Proveedor_Empresa_PK PRIMARY KEY ( Rut ) ;

CREATE TABLE Proveedor_Persona 
    ( 
     Rut       NUMBER (9)  NOT NULL , 
     Nombres   VARCHAR2 (50)  NOT NULL , 
     Apellidos VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE Proveedor_Persona 
    ADD CONSTRAINT Proveedor_Persona_PK PRIMARY KEY ( Rut ) ;

CREATE TABLE Region 
    ( 
     Id_Region     NUMBER (4)  NOT NULL , 
     Nombre_Region VARCHAR2 (25)  NOT NULL 
    ) 
;

ALTER TABLE Region 
    ADD CONSTRAINT Region_PK PRIMARY KEY ( Id_Region ) ;

CREATE TABLE Sucursal 
    ( 
     Sigla_Sucursal   VARCHAR2 (10)  NOT NULL , 
     Nombre_Sucursal  VARCHAR2 (25)  NOT NULL , 
     Comuna_Id_Comuna NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE Sucursal 
    ADD CONSTRAINT Sucursal_PK PRIMARY KEY ( Sigla_Sucursal ) ;

ALTER TABLE Boleta 
    ADD CONSTRAINT Boleta_Cliente_FK FOREIGN KEY 
    ( 
     Cliente_Id_Cliente
    ) 
    REFERENCES Cliente 
    ( 
     Id_Cliente
    ) 
;

ALTER TABLE Cliente 
    ADD CONSTRAINT Cliente_Comuna_FK FOREIGN KEY 
    ( 
     Comuna_Id_Comuna
    ) 
    REFERENCES Comuna 
    ( 
     Id_Comuna
    ) 
;

ALTER TABLE Comuna 
    ADD CONSTRAINT Comuna_Region_FK FOREIGN KEY 
    ( 
     Region_Id_Region
    ) 
    REFERENCES Region 
    ( 
     Id_Region
    ) 
;

ALTER TABLE Detalle_Boleta 
    ADD CONSTRAINT Detalle_Boleta_Boleta_FK FOREIGN KEY 
    ( 
     Boleta_Num_Boleta
    ) 
    REFERENCES Boleta 
    ( 
     Num_Boleta
    ) 
;

ALTER TABLE Detalle_Boleta 
    ADD CONSTRAINT Detalle_Boleta_Producto_FK FOREIGN KEY 
    ( 
     Producto_Id_Producto,
     Producto_Sigla_Sucursal
    ) 
    REFERENCES Producto 
    ( 
     Id_Producto,
     Sucursal_Sigla_Sucursal
    ) 
;

ALTER TABLE Modelo 
    ADD CONSTRAINT Modelo_Marca_FK FOREIGN KEY 
    ( 
     Marca_Id_Marca
    ) 
    REFERENCES Marca 
    ( 
     Id_Marca
    ) 
;

ALTER TABLE Producto 
    ADD CONSTRAINT Producto_Modelo_FK FOREIGN KEY 
    ( 
     Modelo_Id_Modelo,
     Modelo_Marca_Id_Marca
    ) 
    REFERENCES Modelo 
    ( 
     Id_Modelo,
     Marca_Id_Marca
    ) 
;

ALTER TABLE Producto 
    ADD CONSTRAINT Producto_Proveedor_FK FOREIGN KEY 
    ( 
     Proveedor_Rut
    ) 
    REFERENCES Proveedor 
    ( 
     Rut
    ) 
;

ALTER TABLE Producto 
    ADD CONSTRAINT Producto_Sucursal_FK FOREIGN KEY 
    ( 
     Sucursal_Sigla_Sucursal
    ) 
    REFERENCES Sucursal 
    ( 
     Sigla_Sucursal
    ) 
;

ALTER TABLE Proveedor 
    ADD CONSTRAINT Proveedor_Comuna_FK FOREIGN KEY 
    ( 
     Comuna_Id_Comuna
    ) 
    REFERENCES Comuna 
    ( 
     Id_Comuna
    ) 
;

ALTER TABLE Proveedor_Empresa 
    ADD CONSTRAINT Proveedor_Empresa_Proveedor_FK FOREIGN KEY 
    ( 
     Rut
    ) 
    REFERENCES Proveedor 
    ( 
     Rut
    ) 
;

ALTER TABLE Proveedor_Persona 
    ADD CONSTRAINT Proveedor_Persona_Proveedor_FK FOREIGN KEY 
    ( 
     Rut
    ) 
    REFERENCES Proveedor 
    ( 
     Rut
    ) 
;

ALTER TABLE Sucursal 
    ADD CONSTRAINT Sucursal_Comuna_FK FOREIGN KEY 
    ( 
     Comuna_Id_Comuna
    ) 
    REFERENCES Comuna 
    ( 
     Id_Comuna
    ) 
;

CREATE OR REPLACE TRIGGER ARC_FKArc_1_Proveedor_Persona 
BEFORE INSERT OR UPDATE OF Rut 
ON Proveedor_Persona 
FOR EACH ROW 
DECLARE 
    d CHAR (1); 
BEGIN 
    SELECT A.Tipo_Proveedor INTO d 
    FROM Proveedor A 
    WHERE A.Rut = :new.Rut; 
    IF (d IS NULL OR d <> 'P') THEN 
        raise_application_error(-20223,'FK Proveedor_Persona_Proveedor_FK in Table Proveedor_Persona violates Arc constraint on Table Proveedor - discriminator column Tipo_Proveedor doesn''t have value ''P'''); 
    END IF; 
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        NULL; 
    WHEN OTHERS THEN 
        RAISE; 
END; 
/

CREATE OR REPLACE TRIGGER ARC_FKArc_1_Proveedor_Empresa 
BEFORE INSERT OR UPDATE OF Rut 
ON Proveedor_Empresa 
FOR EACH ROW 
DECLARE 
    d CHAR (1); 
BEGIN 
    SELECT A.Tipo_Proveedor INTO d 
    FROM Proveedor A 
    WHERE A.Rut = :new.Rut; 
    IF (d IS NULL OR d <> 'E') THEN 
        raise_application_error(-20223,'FK Proveedor_Empresa_Proveedor_FK in Table Proveedor_Empresa violates Arc constraint on Table Proveedor - discriminator column Tipo_Proveedor doesn''t have value ''E'''); 
    END IF; 
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        NULL; 
    WHEN OTHERS THEN 
        RAISE; 
END; 
/



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            12
-- CREATE INDEX                             0
-- ALTER TABLE                             25
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           2
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
