
DROP TABLE DOSIS        CASCADE CONSTRAINTS;
DROP TABLE PAGO         CASCADE CONSTRAINTS;
DROP TABLE RECETA       CASCADE CONSTRAINTS;

DROP TABLE MEDICAMENTO  CASCADE CONSTRAINTS;
DROP TABLE DIAGNOSTICO  CASCADE CONSTRAINTS;
DROP TABLE TIPO_RECETA  CASCADE CONSTRAINTS;

DROP TABLE PACIENTE     CASCADE CONSTRAINTS;
DROP TABLE DIGITADOR    CASCADE CONSTRAINTS;
DROP TABLE MEDICO       CASCADE CONSTRAINTS;

DROP TABLE COMUNA       CASCADE CONSTRAINTS;
DROP TABLE CIUDAD       CASCADE CONSTRAINTS;
DROP TABLE REGION       CASCADE CONSTRAINTS;

DROP TABLE ESPECIALIDAD CASCADE CONSTRAINTS;
DROP TABLE BANCO        CASCADE CONSTRAINTS;


-- CASO 1

-- REGION
CREATE TABLE REGION (
  id_region   NUMBER(5) NOT NULL,
  nombre      VARCHAR2(25) NOT NULL
);

ALTER TABLE REGION
  ADD CONSTRAINT region_pk PRIMARY KEY (id_region);

ALTER TABLE REGION
  ADD CONSTRAINT region_nombre_uq UNIQUE (nombre);


-- CIUDAD
CREATE TABLE CIUDAD (
  id_ciudad   NUMBER(5) NOT NULL,
  nombre      VARCHAR2(25) NOT NULL,
  id_region   NUMBER(5) NOT NULL
);

ALTER TABLE CIUDAD
  ADD CONSTRAINT ciudad_pk PRIMARY KEY (id_ciudad);

ALTER TABLE CIUDAD
  ADD CONSTRAINT ciudad_region_fk FOREIGN KEY (id_region)
  REFERENCES REGION (id_region);

ALTER TABLE CIUDAD
  ADD CONSTRAINT ciudad_nombre_uq UNIQUE (nombre, id_region);


-- COMUNA
CREATE TABLE COMUNA (
  id_comuna   NUMBER(5) GENERATED ALWAYS AS IDENTITY (START WITH 1101 INCREMENT BY 1) NOT NULL,
  nombre      VARCHAR2(25) NOT NULL,
  id_ciudad   NUMBER(5) NOT NULL
);

ALTER TABLE COMUNA
  ADD CONSTRAINT comuna_pk PRIMARY KEY (id_comuna);

ALTER TABLE COMUNA
  ADD CONSTRAINT comuna_ciudad_fk FOREIGN KEY (id_ciudad)
  REFERENCES CIUDAD (id_ciudad);

ALTER TABLE COMUNA
  ADD CONSTRAINT comuna_nombre_uq UNIQUE (nombre, id_ciudad);


-- ESPECIALIDAD 
CREATE TABLE ESPECIALIDAD (
  id_especialidad NUMBER(5) GENERATED ALWAYS AS IDENTITY NOT NULL,
  nombre          VARCHAR2(50) NOT NULL
);

ALTER TABLE ESPECIALIDAD
  ADD CONSTRAINT especialidad_pk PRIMARY KEY (id_especialidad);

ALTER TABLE ESPECIALIDAD
  ADD CONSTRAINT especialidad_nombre_uq UNIQUE (nombre);


-- BANCO
CREATE TABLE BANCO (
  cod_banco NUMBER(2) NOT NULL,
  nombre    VARCHAR2(25) NOT NULL
);

ALTER TABLE BANCO
  ADD CONSTRAINT banco_pk PRIMARY KEY (cod_banco);

ALTER TABLE BANCO
  ADD CONSTRAINT banco_nombre_uq UNIQUE (nombre);


-- DIGITADOR 
CREATE TABLE DIGITADOR (
  rut_digitador NUMBER(8) NOT NULL,
  dv_digitador CHAR(1) NOT NULL,
  pnombre      VARCHAR2(25) NOT NULL,
  papellido    VARCHAR2(25) NOT NULL
);

ALTER TABLE DIGITADOR
  ADD CONSTRAINT digitador_pk PRIMARY KEY (rut_digitador);

ALTER TABLE DIGITADOR
  ADD CONSTRAINT digitador_dv_ck CHECK (dv_digitador IN ('0','1','2','3','4','5','6','7','8','9','K'));


-- MEDICO 
CREATE TABLE MEDICO (
  rut_med         NUMBER(8) NOT NULL,
  dv_med          CHAR(1) NOT NULL,
  pnombre         VARCHAR2(25) NOT NULL,
  snombre         VARCHAR2(25),
  papellido       VARCHAR2(25) NOT NULL,
  sapellido       VARCHAR2(25),
  telefono        NUMBER(11) NOT NULL,
  id_especialidad NUMBER(5) NOT NULL
);

ALTER TABLE MEDICO
  ADD CONSTRAINT medico_pk PRIMARY KEY (rut_med);

ALTER TABLE MEDICO
  ADD CONSTRAINT medico_dv_ck CHECK (dv_med IN ('0','1','2','3','4','5','6','7','8','9','K'));

ALTER TABLE MEDICO
  ADD CONSTRAINT medico_telefono_uq UNIQUE (telefono);

ALTER TABLE MEDICO
  ADD CONSTRAINT medico_especialidad_fk FOREIGN KEY (id_especialidad)
  REFERENCES ESPECIALIDAD (id_especialidad);


-- PACIENTE 
CREATE TABLE PACIENTE (
  rut_pac    NUMBER(8) NOT NULL,
  dv_pac     CHAR(1) NOT NULL,
  pnombre    VARCHAR2(25) NOT NULL,
  snombre    VARCHAR2(25),
  edad       NUMBER(3),              
  telefono   NUMBER(11) NOT NULL,
  calle      VARCHAR2(50) NOT NULL,
  numeracion NUMBER(5) NOT NULL,
  comuna     NUMBER(5) NOT NULL,
  ciudad     NUMBER(5) NOT NULL,
  region     NUMBER(5) NOT NULL
);

ALTER TABLE PACIENTE
  ADD CONSTRAINT paciente_pk PRIMARY KEY (rut_pac);

ALTER TABLE PACIENTE
  ADD CONSTRAINT paciente_dv_ck CHECK (dv_pac IN ('0','1','2','3','4','5','6','7','8','9','K'));

ALTER TABLE PACIENTE
  ADD CONSTRAINT paciente_region_fk FOREIGN KEY (region)
  REFERENCES REGION (id_region);

ALTER TABLE PACIENTE
  ADD CONSTRAINT paciente_ciudad_fk FOREIGN KEY (ciudad)
  REFERENCES CIUDAD (id_ciudad);

ALTER TABLE PACIENTE
  ADD CONSTRAINT paciente_comuna_fk FOREIGN KEY (comuna)
  REFERENCES COMUNA (id_comuna);


-- DIAGNOSTICO
CREATE TABLE DIAGNOSTICO (
  cod_diagnostico NUMBER(3) NOT NULL,
  nombre          VARCHAR2(25) NOT NULL
);

ALTER TABLE DIAGNOSTICO
  ADD CONSTRAINT diagnostico_pk PRIMARY KEY (cod_diagnostico);

ALTER TABLE DIAGNOSTICO
  ADD CONSTRAINT diagnostico_nombre_uq UNIQUE (nombre);


-- TIPO_RECETA 
CREATE TABLE TIPO_RECETA (
  id_tipo_receta NUMBER(3) NOT NULL,
  nombre         VARCHAR2(20) NOT NULL
);

ALTER TABLE TIPO_RECETA
  ADD CONSTRAINT tipo_receta_pk PRIMARY KEY (id_tipo_receta);

ALTER TABLE TIPO_RECETA
  ADD CONSTRAINT tipo_receta_nombre_ck
  CHECK (nombre IN ('DIGITAL','MAGISTRAL','RETENIDA','GENERAL','VETERINARIA'));

ALTER TABLE TIPO_RECETA
  ADD CONSTRAINT tipo_receta_nombre_uq UNIQUE (nombre);


-- MEDICAMENTO
CREATE TABLE MEDICAMENTO (
  cod_medicamento   NUMBER(7) NOT NULL,
  nombre            VARCHAR2(25) NOT NULL,
  dosis_recomendada VARCHAR2(25) NOT NULL,
  stock_disponible  NUMBER(10) DEFAULT 0 NOT NULL,
  tipo_medicamento  VARCHAR2(20) NOT NULL
);

ALTER TABLE MEDICAMENTO
  ADD CONSTRAINT medicamento_pk PRIMARY KEY (cod_medicamento);

ALTER TABLE MEDICAMENTO
  ADD CONSTRAINT medicamento_stock_ck CHECK (stock_disponible >= 0);

ALTER TABLE MEDICAMENTO
  ADD CONSTRAINT medicamento_tipo_ck CHECK (tipo_medicamento IN ('GENERICO','MARCA'));


-- RECETA 
CREATE TABLE RECETA (
  cod_receta        NUMBER(7) GENERATED ALWAYS AS IDENTITY NOT NULL,
  observaciones     VARCHAR2(500),
  fecha_emision     DATE NOT NULL,
  fecha_vencimiento DATE,
  rut_digitador      NUMBER(8) NOT NULL,
  rut_pac           NUMBER(8) NOT NULL,
  cod_diagnostico    NUMBER(3) NOT NULL,
  rut_med           NUMBER(8) NOT NULL,
  id_tipo_receta    NUMBER(3) NOT NULL
);

ALTER TABLE RECETA
  ADD CONSTRAINT receta_pk PRIMARY KEY (cod_receta);

ALTER TABLE RECETA
  ADD CONSTRAINT receta_digitador_fk FOREIGN KEY (rut_digitador)
  REFERENCES DIGITADOR (rut_digitador);

ALTER TABLE RECETA
  ADD CONSTRAINT receta_paciente_fk FOREIGN KEY (rut_pac)
  REFERENCES PACIENTE (rut_pac);

ALTER TABLE RECETA
  ADD CONSTRAINT receta_diagnostico_fk FOREIGN KEY (cod_diagnostico)
  REFERENCES DIAGNOSTICO (cod_diagnostico);

ALTER TABLE RECETA
  ADD CONSTRAINT receta_medico_fk FOREIGN KEY (rut_med)
  REFERENCES MEDICO (rut_med);

ALTER TABLE RECETA
  ADD CONSTRAINT receta_tipo_fk FOREIGN KEY (id_tipo_receta)
  REFERENCES TIPO_RECETA (id_tipo_receta);


-- DOSIS 
CREATE TABLE DOSIS (
  cod_medicamento    NUMBER(7) NOT NULL,
  cod_receta         NUMBER(7) NOT NULL,
  descripcion_dosis VARCHAR2(25) NOT NULL
);

ALTER TABLE DOSIS
  ADD CONSTRAINT dosis_pk PRIMARY KEY (cod_medicamento, cod_receta);

ALTER TABLE DOSIS
  ADD CONSTRAINT dosis_medicamento_fk FOREIGN KEY (cod_medicamento)
  REFERENCES MEDICAMENTO (cod_medicamento);

ALTER TABLE DOSIS
  ADD CONSTRAINT dosis_receta_fk FOREIGN KEY (cod_receta)
  REFERENCES RECETA (cod_receta);


-- PAGO 
CREATE TABLE PAGO (
  cod_boleta  NUMBER(6) NOT NULL,
  cod_receta   NUMBER(7) NOT NULL,
  fecha_pago  DATE NOT NULL,
  monto_total NUMBER(12) NOT NULL,
  metodo_pago VARCHAR2(15) NOT NULL,
  cod_banco    NUMBER(2)
);

ALTER TABLE PAGO
  ADD CONSTRAINT pago_pk PRIMARY KEY (cod_boleta);

ALTER TABLE PAGO
  ADD CONSTRAINT pago_receta_fk FOREIGN KEY (cod_receta)
  REFERENCES RECETA (cod_receta);

ALTER TABLE PAGO
  ADD CONSTRAINT pago_banco_fk FOREIGN KEY (cod_banco)
  REFERENCES BANCO (cod_banco);

ALTER TABLE PAGO
  ADD CONSTRAINT pago_monto_ck CHECK (monto_total > 0);



-- CASO 2

-- 1) Se agrega precio unitario y se valida rango $1.000 a $2.000.000
ALTER TABLE MEDICAMENTO
  ADD precio_unitario NUMBER(12) DEFAULT 1000 NOT NULL;

ALTER TABLE MEDICAMENTO
  ADD CONSTRAINT medicamento_precio_ck
  CHECK (precio_unitario BETWEEN 1000 AND 2000000);


-- 2) Metodos de pago: EFECTIVO, TARJETA, TRANSFERENCIA
ALTER TABLE PAGO
  ADD CONSTRAINT pago_metodo_ck
  CHECK (metodo_pago IN ('EFECTIVO','TARJETA','TRANSFERENCIA'));


-- 3) Se elimina edad y se agrega fecha_nacimiento
ALTER TABLE PACIENTE
  DROP COLUMN edad;

ALTER TABLE PACIENTE
  ADD fecha_nacimiento DATE NOT NULL;
