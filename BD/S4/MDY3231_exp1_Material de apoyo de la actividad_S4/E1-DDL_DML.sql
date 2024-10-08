DROP TABLE DETALLE_FACTURA;
DROP TABLE FACTURA;
DROP TABLE DETALLE_BOLETA;
DROP TABLE BOLETA;
DROP TABLE PRODUCTO;
DROP TABLE UNIDAD_MEDIDA; 
DROP TABLE PAIS;
DROP TABLE CLIENTE;
DROP TABLE VENDEDOR;
DROP TABLE FORMA_PAGO;
DROP TABLE BANCO;
DROP TABLE COMUNA;
DROP TABLE CIUDAD;
DROP TABLE DETALLE_VENTA;
drop table producto_historico;
DROP TABLE TRAMO_ANTIGUEDAD;
DROP TABLE TRAMO_ESCOLARIDAD;
DROP TABLE PAGO_VENDEDOR;
DROP TABLE historico_venta_producto;

CREATE TABLE PAGO_VENDEDOR 
(
 RUTVENDEDOR    	VARCHAR2(10),
 NOMVENDEDOR    	VARCHAR2(30),
 SUELDO_BASE    	NUMBER(8),
 COLACION       	NUMBER(8),
 MOVILIZACION   	NUMBER(8),
 PREVISION      	NUMBER(8),
 SALUD          	NUMBER(8),
 COMISION         	NUMBER(2,2),
 MONTO_COMISION		NUMBER(8),
 MONTO_VENTA      	NUMBER(8),
 TOTAL_BONOS		NUMBER(8),
 TOTAL_HABERES		NUMBER(8),
 TOTAL_DESCTOS		NUMBER(8),
 TOTAL_PAGAR    	NUMBER(8) 
);



CREATE TABLE TRAMO_ANTIGUEDAD
(
  SEC_ANNOS_CONTRATADO NUMBER(2),
  ANNOS_CONT_INF       NUMBER(2),
  ANNOS_CONT_SUP       NUMBER(2), 
  PORCENTAJE	       NUMBER(2)
);

CREATE TABLE TRAMO_ESCOLARIDAD
(
  ID_ESCOLARIDAD     	NUMBER(2),
  SIGLA_ESCOLARIDAD  	VARCHAR2(5),
  DESC_ESCOLARIDAD   	VARCHAR2(50),
  PORC_ASIG_ESCOLARIDAD NUMBER(2)
);


CREATE TABLE DETALLE_VENTA 
(
 NUMDOCTO	     	NUMBER(10),
 TIPODOC		    VARCHAR2(3),
 FECHA         		DATE,
 RUTCLIENTE		  VARCHAR2(10),
 NOMCLIENTE 		VARCHAR2(30),
 RUTVENDEDOR		VARCHAR2(10),
 NOMVENDEDOR		VARCHAR2(30),
 NETO        		NUMBER(8,2),
 IVA        		NUMBER(8,2),
 TOTAL        	NUMBER(8,2)
);

CREATE TABLE CIUDAD  
(
 CODCIUDAD 	NUMBER (2), 
 DESCRIPCION 	VARCHAR2(30)
);

ALTER TABLE CIUDAD 
    ADD CONSTRAINT COD_CIUDAD_PK PRIMARY KEY (CODCIUDAD);

CREATE TABLE COMUNA
(
 CODCOMUNA 	NUMBER (2), 
 DESCRIPCION 	VARCHAR2(30),
 CODCIUDAD 	NUMBER(2)
);

ALTER TABLE COMUNA 
    ADD CONSTRAINT COD_COMUNA_PK PRIMARY KEY (CODCOMUNA);

ALTER TABLE COMUNA 
    ADD CONSTRAINT COD_CIUDAD_FK FOREIGN KEY (CODCIUDAD) REFERENCES CIUDAD (CODCIUDAD);

CREATE TABLE CLIENTE
(
  RUTCLIENTE  		VARCHAR2(10),
  NOMBRE      		VARCHAR2(30),
  DIRECCION   		VARCHAR2(30),
  CODCOMUNA   		NUMBER (2),
  TELEFONO    		NUMBER(10),
  ESTADO      		VARCHAR2(1),
  MAIL			VARCHAR2(50),
  CREDITO     		NUMBER (7),
  SALDO       		NUMBER (7),
  DESCUENTO_VIGENTE NUMBER(7)
);

ALTER TABLE CLIENTE
    ADD CONSTRAINT RUT_CLIENTE_PK
    PRIMARY KEY (RUTCLIENTE);

ALTER TABLE CLIENTE
    ADD CONSTRAINT ESTADO_CLIENTE_CK
    CHECK (ESTADO IN ('A', 'B', 'C') );

ALTER TABLE CLIENTE 
    ADD CONSTRAINT COD_COMUNA_FK 
    FOREIGN KEY (CODCOMUNA) REFERENCES COMUNA (CODCOMUNA);


CREATE TABLE VENDEDOR
(
  ID		        NUMBER(2),
  RUTVENDEDOR 		VARCHAR2(10),
  NOMBRE      		VARCHAR2(30),
  DIRECCION   		VARCHAR2(30),
  CODCOMUNA   		NUMBER (2),
  TELEFONO    		NUMBER(10),
  MAIL			VARCHAR2(50),
  SUELDO_BASE		NUMBER(8),
  COMISION		NUMBER(2,2),
  FECHA_CONTRATO	DATE,
  ESCOLARIDAD		NUMBER(2)
);

ALTER TABLE VENDEDOR
    ADD CONSTRAINT RUT_VENDEDOR_PK
    PRIMARY KEY (RUTVENDEDOR);

ALTER TABLE VENDEDOR 
    ADD CONSTRAINT VENDEDOR_COD_COMUNA_FK 
    FOREIGN KEY (CODCOMUNA) REFERENCES COMUNA (CODCOMUNA);

CREATE TABLE  UNIDAD_MEDIDA 
   (
    CODUNIDAD 	VARCHAR2(2), 
    DESCRIPCION	VARCHAR2(30) 
   );

ALTER TABLE UNIDAD_MEDIDA 
      ADD CONSTRAINT COD_UNIDAD_PK 
      PRIMARY KEY (CODUNIDAD);

CREATE TABLE  PAIS 
   (
    CODPAIS 	NUMBER(2), 
    NOMPAIS	VARCHAR2(30) 
   );

ALTER TABLE PAIS 
      ADD CONSTRAINT PAIS_PK 
      PRIMARY KEY (CODPAIS);

CREATE TABLE  PRODUCTO 
   (
    CODPRODUCTO  	NUMBER(3), 
    DESCRIPCION   	VARCHAR2(40), 
    CODUNIDAD     	VARCHAR2(2), 
    CODCATEGORIA    	VARCHAR2(1), 
    VUNITARIO    	NUMBER(8), 
    VALORCOMPRAPESO    	NUMBER(8), 
    VALORCOMPRADOLAR   NUMBER(8,2), 
    TOTALSTOCK   	NUMBER (5),
    STKSEGURIDAD  	NUMBER (5),    
    PROCEDENCIA   	VARCHAR2(1),
    CODPAIS		NUMBER(2),
    CODPRODUCTO_REL	NUMBER(3)
   );

ALTER TABLE PRODUCTO 
      ADD CONSTRAINT COD_PROD_PK 
      PRIMARY KEY (CODPRODUCTO);

ALTER TABLE PRODUCTO 
      ADD CONSTRAINT COD_UNIDAD_FK 
      FOREIGN KEY (CODUNIDAD) REFERENCES UNIDAD_MEDIDA (CODUNIDAD);

ALTER TABLE PRODUCTO 
      ADD CONSTRAINT COD_PAIS_FK 
      FOREIGN KEY (CODPAIS) REFERENCES PAIS (CODPAIS);

ALTER TABLE PRODUCTO 
      ADD CONSTRAINT CODPRODUCTO_REL_FK 
      FOREIGN KEY (CODPRODUCTO_REL) REFERENCES PRODUCTO (CODPRODUCTO);

CREATE TABLE  FORMA_PAGO 
   (
    CODPAGO 	NUMBER(2), 
    DESCRIPCION	VARCHAR2(30) 
   );

ALTER TABLE FORMA_PAGO 
      ADD CONSTRAINT CODPAGO_PK 
      PRIMARY KEY (CODPAGO);

CREATE TABLE  BANCO 
   (
    CODBANCO 	NUMBER(2), 
    DESCRIPCION	VARCHAR2(30) 
   );

ALTER TABLE BANCO 
      ADD CONSTRAINT CODBANCO_PK 
      PRIMARY KEY (CODBANCO);

CREATE TABLE FACTURA
(
  NUMFACTURA  		NUMBER(7),
  RUTCLIENTE  		VARCHAR2(10),
  RUTVENDEDOR     	VARCHAR2(10),
  FECHA       		DATE,
  F_VENCIMIENTO	DATE,
  NETO        		NUMBER (7),	
  IVA         		NUMBER (7),
  TOTAL       		NUMBER (7),
  CODBANCO		NUMBER(2),
  CODPAGO		NUMBER(2),
  NUM_DOCTO_PAGO	VARCHAR2(30),
  ESTADO      		VARCHAR2(2)
);

ALTER TABLE FACTURA 
      ADD CONSTRAINT NUMFACTURA_PK 
      PRIMARY KEY (NUMFACTURA);

ALTER TABLE FACTURA 
      ADD CONSTRAINT RUTCLIENTE_FK 
      FOREIGN KEY (RUTCLIENTE) REFERENCES CLIENTE (RUTCLIENTE);

ALTER TABLE FACTURA 
      ADD CONSTRAINT RUTVENDEDOR_FK 
      FOREIGN KEY (RUTVENDEDOR) REFERENCES VENDEDOR (RUTVENDEDOR);

ALTER TABLE FACTURA 
      ADD CONSTRAINT CODPAGO_FK 
      FOREIGN KEY (CODPAGO) REFERENCES FORMA_PAGO (CODPAGO);

ALTER TABLE FACTURA 
      ADD CONSTRAINT CODBANCO_FK 
      FOREIGN KEY (CODBANCO) REFERENCES BANCO (CODBANCO);

ALTER TABLE FACTURA
      ADD CONSTRAINT ESTADO_FACTURA_CK
      CHECK (ESTADO IN ('EM', 'PA','NC') );

CREATE TABLE DETALLE_FACTURA 
   (
    NUMFACTURA 	NUMBER (7), 
    CODPRODUCTO 	NUMBER (3), 
    VUNITARIO    		NUMBER(8),  
    CODPROMOCION	NUMBER (4),
    DESCRI_PROM   	VARCHAR2(60), 
    DESCUENTO		NUMBER(8),
    CANTIDAD 		NUMBER (5), 
    TOTALLINEA 		NUMBER(8)
   );

ALTER TABLE DETALLE_FACTURA 
      ADD CONSTRAINT DET_FACT_PK 
      PRIMARY KEY (NUMFACTURA, CODPRODUCTO);

ALTER TABLE DETALLE_FACTURA 
      ADD CONSTRAINT COD_PROD_FK 
      FOREIGN KEY (CODPRODUCTO) REFERENCES PRODUCTO (CODPRODUCTO);


ALTER TABLE DETALLE_FACTURA 
      ADD CONSTRAINT NUM_FACT_FK 
      FOREIGN KEY (NUMFACTURA) REFERENCES FACTURA (NUMFACTURA);

CREATE TABLE BOLETA
(
  NUMBOLETA  		NUMBER(7),
  RUTCLIENTE  		VARCHAR2(10),
  RUTVENDEDOR     	VARCHAR2(10),
  FECHA       		DATE,
  TOTAL       		NUMBER (7),
  CODPAGO		NUMBER(2),
  CODBANCO		NUMBER(2),
  NUM_DOCTO_PAGO	VARCHAR2(30),
  ESTADO      		VARCHAR2(2)
);

ALTER TABLE BOLETA 
      ADD CONSTRAINT NUMBOLETA_PK 
      PRIMARY KEY (NUMBOLETA);

ALTER TABLE BOLETA 
      ADD CONSTRAINT BOL_RUTCLIENTE_FK 
      FOREIGN KEY (RUTCLIENTE) REFERENCES CLIENTE (RUTCLIENTE);

ALTER TABLE BOLETA 
      ADD CONSTRAINT BOL_RUTVENDEDOR_FK 
      FOREIGN KEY (RUTVENDEDOR) REFERENCES VENDEDOR (RUTVENDEDOR);

     
ALTER TABLE BOLETA 
      ADD CONSTRAINT BOL_CODPAGO_FK 
      FOREIGN KEY (CODPAGO) REFERENCES FORMA_PAGO (CODPAGO);

ALTER TABLE BOLETA 
      ADD CONSTRAINT BOL_CODBANCO_FK 
      FOREIGN KEY (CODBANCO) REFERENCES BANCO (CODBANCO);

ALTER TABLE BOLETA
      ADD CONSTRAINT BOL_ESTADO_BOLETA_CK
      CHECK (ESTADO IN ('EM', 'PA','NC') );

CREATE TABLE DETALLE_BOLETA 
   (
    NUMBOLETA	 	NUMBER (7), 
    CODPRODUCTO 	NUMBER (3), 
    VUNITARIO    		NUMBER(8),  
    CODPROMOCION	NUMBER (4),
    DESCRI_PROM   	VARCHAR2(60), 
    DESCUENTO		NUMBER(8),
    CANTIDAD 		NUMBER (5), 
    TOTALLINEA 		NUMBER(8)
   );

ALTER TABLE DETALLE_BOLETA 
      ADD CONSTRAINT DET_BOLETA_PK 
      PRIMARY KEY (NUMBOLETA, CODPRODUCTO);

ALTER TABLE DETALLE_BOLETA 
      ADD CONSTRAINT DET_BOL_CODPRODUCTO_FK 
      FOREIGN KEY (CODPRODUCTO) REFERENCES PRODUCTO (CODPRODUCTO);

ALTER TABLE DETALLE_BOLETA 
      ADD CONSTRAINT DET_BOL_NUM_BOLETA_FK 
      FOREIGN KEY (NUMBOLETA) REFERENCES BOLETA (NUMBOLETA);


DROP TABLE resumen_cliente;
CREATE TABLE resumen_cliente
(
    rut_cliente VARCHAR2(25) PRIMARY KEY,
    nombre_cliente VARCHAR2(45) NOT NULL,
    nombre_comuna VARCHAR2(45) NOT NULL,
    total_documentos NUMBER NOT NULL,
    credito VARCHAR2(25) NOT NULL
);

DROP TABLE resumen_producto;
CREATE TABLE resumen_producto(
  cod_producto NUMBER PRIMARY KEY,
  total_boletas NUMBER NOT NULL,
  total_unidades NUMBER NOT NULL,
  valor_unitario NUMBER NOT NULL,
  porcentaje_aplicado NUMBER NOT NULL,
  precio NUMBER NOT NULL
);

DROP TABLE tramo_precio;

CREATE TABLE tramo_precio
(
      id_tramo NUMBER PRIMARY KEY,
      valor_minimo NUMBER NOT NULL,
      valor_maximo NUMBER NOT NULL,
      porcentaje NUMBER(5,2) NOT NULL
);

-- Datos de tabla
INSERT INTO tramo_precio VALUES(1, 1, 9999, 0.05);
INSERT INTO tramo_precio VALUES(2, 10000, 19999, 0.07);
INSERT INTO tramo_precio VALUES(3, 20000, 29999, 0.09);
INSERT INTO tramo_precio VALUES(4, 30000, 49999, 0.1);
INSERT INTO tramo_precio VALUES(5, 50000, 99999, 0.15);

INSERT INTO CIUDAD VALUES (1,'ARICA');
INSERT INTO CIUDAD VALUES (2,'IQUIQUE');
INSERT INTO CIUDAD VALUES (3,'CALAMA');
INSERT INTO CIUDAD VALUES (4,'ANTOFAGASTA');
INSERT INTO CIUDAD VALUES (5,'COPIAPO');
INSERT INTO CIUDAD VALUES (6,'LA SERENA');
INSERT INTO CIUDAD VALUES (7,'VALPARAISO');
INSERT INTO CIUDAD VALUES (8,'SANTIAGO');
INSERT INTO CIUDAD VALUES (9,'RANCAGUA');
INSERT INTO CIUDAD VALUES (10,'TALCA');
INSERT INTO CIUDAD VALUES (11,'CONCEPCION');
INSERT INTO CIUDAD VALUES (12,'TEMUCO');
INSERT INTO CIUDAD VALUES (13,'VALDIVIA');
INSERT INTO CIUDAD VALUES (14,'OSORNO');
INSERT INTO CIUDAD VALUES (15,'PTO. MONTT');
INSERT INTO CIUDAD VALUES (16,'COYHAIQUE');
INSERT INTO CIUDAD VALUES (17,'PTA. ARENAS');

INSERT INTO COMUNA VALUES (1,'VITACURA',8);
INSERT INTO COMUNA VALUES (2,'NUNOA',8);
INSERT INTO COMUNA VALUES (3,'PENALOLEN',8);
INSERT INTO COMUNA VALUES (4,'SANTIAGO',8);
INSERT INTO COMUNA VALUES (5,'VALDIVIA',13);
INSERT INTO COMUNA VALUES (6,'EL LOA',3);
INSERT INTO COMUNA VALUES (7,'CHILLAN',11);
INSERT INTO COMUNA VALUES (8,'PROVIDENCIA',8);
INSERT INTO COMUNA VALUES (9,'PTO.SAAVEDRA',14);

INSERT INTO FORMA_PAGO VALUES (1,'EFECTIVO');
INSERT INTO FORMA_PAGO VALUES (2,'TARJETA DEBITO');
INSERT INTO FORMA_PAGO VALUES (3,'TARJETA CREDITO');
INSERT INTO FORMA_PAGO VALUES (4,'CHEQUE');

INSERT INTO BANCO VALUES (1,'CHILE');
INSERT INTO BANCO VALUES (2,'SANTANDER');
INSERT INTO BANCO VALUES (3,'BCI');
INSERT INTO BANCO VALUES (4,'CORP BANCA');
INSERT INTO BANCO VALUES (5,'BBVA');
INSERT INTO BANCO VALUES (6,'SCOTIBANK');
INSERT INTO BANCO VALUES (7,'SECURITY');

INSERT INTO UNIDAD_MEDIDA VALUES ('UN','UNITARIO');
INSERT INTO UNIDAD_MEDIDA VALUES ('LQ','LIQUIDO');

INSERT INTO PAIS VALUES (1,'CHILE');
INSERT INTO PAIS VALUES (2,'EEUU');
INSERT INTO PAIS VALUES (3,'INGLATERRA');
INSERT INTO PAIS VALUES (4,'ALEMANIA');
INSERT INTO PAIS VALUES (5,'FRANCIA');
INSERT INTO PAIS VALUES (6,'CANADA');
INSERT INTO PAIS VALUES (7,'ARGENTINA');
INSERT INTO PAIS VALUES (8,'BRASIL');

insert into cliente values ('6245678-1','JUAN LOPEZ','ALAMEDA 6152',8,96644123,'A','JLOPEZ@GMAIL.COM',1000000,696550, 0);
insert into cliente values ('7812354-2','MARIA SANTANDER','APOQUINDO 9093',8,961682456,'A','MSANTANDER@HOTMAIL.COM',1000000,819120, 0);
insert into cliente values ('9912478-3','SIGIFRIDO SILVA','BILBAO 6200',8,55877315,'B','SSILVA@GMAIL.COM',1500000,0, 0);
insert into cliente values ('14456789-4','OSCAR LARA','ALAMEDA 960',NULL,79888222,'A','OLARA@GMAIL.COM',2500000,2000000, 0);
insert into cliente values ('11245678-5','MARCO ITURRA','ALAMEDA 1056',8,94577804,'A','MITURRA@YAHOO.COM',3000000,2332410, 0);
insert into cliente values ('6467708-6','MARIBEL SOTO','VICUNA MACKENNA 4555',4,95514545,'A','MSOTO@GMAIL.COM',1800000,1200000, 0);
insert into cliente values ('10125945-7','SABINA VERGARA','AV. LA FLORIDA 15554 ',4,88656285,'A','SVERGARA@GMAIL.COM',500000,150000,0 );
insert into cliente values ('8125781-8','PATRICIA FUENTES','IRARRAZABAL 5452',2,74545904,'A','PFUENTES@HOTMAIL.COM',450000,50000, 0);
insert into cliente values ('13746912-9','ABRAHAM IGLESIAS','ALAMEDA 454',4,91452303,'A','AIGLESIAS@YAHOO.COM',100000,90000,0);
insert into cliente values ('5446780-0','CARLOS MENDOZA','PANAMERICANA 152',1,95754782,'A','CMENDOZA@GMAIL.COM',800000,550000,0);
insert into cliente values ('10812874-0','LIDIA FUENZALIDA','PROVIDENCIA 4587 ',NULL,78544452,'A','LFUENZALIDA@GMAIL.COM',1900000,790000,0);
insert into cliente values ('15123587-1','BRAULIO GUTIERREZ','PROVIDENCIA 5400',NULL,NULL,'B','BGUTIERREZ@HOTMAIL.COM',2500000,0,0);
insert into cliente values ('12444650-7','RUBEN PANTOJA','AV. GRECIA 152',4,NULL,'B','RPANTOJA@YAHOO.COM',100000,0,0);
insert into cliente values ('13685017-1','JOHNNY YANEZ','PROVIDENCIA 2900',NULL,78598619,'A','JYANEZ@GMAIL.COM',1200000,200000, 0);
insert into cliente values ('10675908-1','JAIME SALAMANCA','FREIRE 2900',NULL,78598555,'A','JSALAMANCA@GMAIL.COM',1000000,1000000, 0);
insert into cliente values ('11755017-K','ANDREA LARA','PROVIDENCIA 12763',NULL,85448619,'A','ALARA@GMAIL.COM',1200000,1200000, 0);

insert into VENDEDOR values (1,'12456778-1','LEOPOLDO ROJAS','ALAMEDA 6152',1,44644123,'LROJAS@GMAIL.COM',240000,0.1,to_date('01-08-2001'),20);
insert into VENDEDOR values (2,'10712354-2','MARIO SOTO ','APOQUINDO 9093',2,651682456,'MSOTO@HOTMAIL.COM',265000,0.2,to_date('18-07-2005'),30);
insert into VENDEDOR values (3,'11124678-3','SALVADOR ALVARADO','BILBAO 6200',3,65877315,'SALVARADO@GMAIL.COM',250000,0.3,to_date('22-03-2008'),40);
insert into VENDEDOR values (4,'10456789-4','LUIS MUNOZ','ALAMEDA 960',4,96888222,'LMUNOZ@GMAIL.COM',270000,0.4,to_date('07-09-2011'),50);


INSERT INTO PRODUCTO VALUES (1, 'ZAPATO HOMBRE MODELO ALL BLACK-0-11'			,'UN','P',25000,4000,7.42,100,10,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (2, 'ZAPATO HOMBRE MODELO LAGO 6-05'			,'UN','P',28000,8890,8.87,90,10,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (3, 'ZAPATO HOMBRE MODELO PADUA 6-43'			,'UN','P',55000,7990,7.09,54,5,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (4, 'ZAPATO HOMBRE MODELO DOZZA 0-03'			,'UN','P',35000,6770.5,07,40,4,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (5, 'ZAPATO HOMBRE MODELO VALIER 3-18'			,'UN','P',49000,3950,4.03,40,4,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (6, 'ZAPATO HOMBRE MODELO MURCIA 0-003'			,'UN','P',27850,5679,7.98,60,6,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (7, 'ZAPATO HOMBRE MODELO SIENA 0-01'			,'UN','P',41990,9500,9.77,87,10,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (8, 'ZAPATO HOMBRE MODELO TAGO 0-87'			,'UN','P',42500,10890,12.76,60,6,'I',8,NULL);
INSERT INTO PRODUCTO VALUES (9, 'ZAPATO HOMBRE MODELO INDIE 0-16'			,'UN','P',38990,15000,17.85,18,5,'I',8,NULL);
INSERT INTO PRODUCTO VALUES (10,'ZAPATO HOMBRE MODELO NAPOLES 0-17'			,'UN','P',27500,1500,2.01,100,10,'I',8,NULL);

INSERT INTO PRODUCTO VALUES (11,'RENOVADOR LIQUIDO NEUTRO ALTO BRILLO'			,'LQ','A',2850,1200,1.6,150,15,'I',7,NULL);

INSERT INTO PRODUCTO VALUES (12,'ZAPATO MUJER MODELO BOSSA 0-18'			,'UN','P',35000,11000,15.64,70,7,'I',7,NULL);
INSERT INTO PRODUCTO VALUES (13,'ZAPATO MUJER MODELO BRISTOL 1-19'			,'UN','P',29000,6400,8.15,69,10,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (14,'ZAPATO MUJER MODELO RAMBLAS 2-20'			,'UN','P',37980,13980,15.85,35,10,'I',2,NULL);
INSERT INTO PRODUCTO VALUES (15,'ZAPATO MUJER MODELO MOMTREAL 3-201'			,'UN','P',42990,9000,8.77,20,2,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (16,'ZAPATO MUJER MODELO MONTECARLO 4-10'			,'UN','P',56990,5000,5.50,54,10,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (17,'ZAPATO MUJER MODELO LOMBARDO 11-5'			,'UN','P',35990,3800,4.66,34,7,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (18,'ZAPATO MUJER MODELO SYDNEY 12-6'			,'UN','P',32990,7800,6.80,25,10,'I',4,NULL);
INSERT INTO PRODUCTO VALUES (19,'ZAPATO MUJER MODELO BERLIN 4-56'			,'UN','P',52000,1000,NULL,200,20,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (20,'ZAPATO MUJER MODELO MADRID II'				,'UN','P',42500,1200,NULL,90,9,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (21,'ZAPATO MUJER MODELO PIAMONTE D-02'			,'UN','P',34500,480,NULL,100,10,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (22,'ZAPATO MUJER MODELO SERENA 1-019'			,'UN','P',31900,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (23,'ZAPATO MUJER MODELO TWISTER D-100'			,'UN','P',35000,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (24,'ZAPATO MUJER MODELO OSLO 308'				,'UN','P',37000,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (25,'ZAPATO MUJER MODELO CAIRO 0-11'			,'UN','P',43990,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (26,'ZAPATO MUJER MODELO SEVILLA 1-06'			,'UN','P',59900,NULL,NULL,NULL,NULL,'N',1,NULL);

INSERT INTO PRODUCTO VALUES (27,'CREMA PROTECTORA INCOLORO'				,'UN','A',4000,NULL,NULL,NULL,NULL,'N',1,NULL);

INSERT INTO PRODUCTO VALUES (28,'ZAPATO CASUAL HOMBRE BARI 0-10'			,'UN','P',29000,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (29,'ZAPATO CASUAL HOMBREOPORTO 1-108'			,'UN','P',28500,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (30,'BOTIN MUJER PRIMAV 1-17'				,'UN','P',25990,NULL,NULL,NULL,NULL,'N',1,NULL);
INSERT INTO PRODUCTO VALUES (31,'BOTIN MUJER SUMMER 1-17'				,'UN','P',35000,NULL,NULL,NULL,NULL,'N',1,NULL);


UPDATE PRODUCTO 
SET CODPRODUCTO_REL = 11
WHERE CODPRODUCTO <=10;

UPDATE PRODUCTO
SET CODPRODUCTO_REL = 27
WHERE (CODPRODUCTO >=12 AND CODPRODUCTO <=26);


INSERT INTO factura VALUES (11520,'5446780-0','12456778-1',to_date('02/01/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),
    TO_DATE('02/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),100000,19000,119000,1,4,'178904', 'EM');
INSERT INTO factura VALUES (11521,'7812354-2','10712354-2',
TO_DATE('02/01/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),NULL,149000,28310,177310,NULL,1,NULL,'EM');
insert into factura VALUES (11522,'8125781-8','12456778-1',to_date('03/02/' ||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),NULL,209400,39786,249186,2,3,NULL,'PA');
insert into factura VALUES (11523,'5446780-0','11124678-3',to_date('04/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),NULL,37500,7125,44625,NULL,1,NULL,'EM');
insert into factura VALUES (11524,'12444650-7','11124678-3',to_date('15/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),NULL,58455,11606,69561,2,4,NULL,'EM');
insert into factura VALUES (11525,'8125781-8','12456778-1',to_date('16/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)), TO_DATE('16/03/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),30000,5700,35700,2,4,'8904865', 'EM');
insert into factura VALUES (11526,'13685017-1','10456789-4',to_date('17/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),NULL,29700,5643,35343,2,3,NULL,'PA');
insert into factura VALUES (11527,'8125781-8','10712354-2',to_date('07/03/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),NULL,29700,5643,35343,NULL,1,NULL,'EM');
INSERT INTO factura VALUES (11528,'5446780-0','10712354-2',to_date('07/03/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),NULL,29700,5643,35343,2,4,'CF-123647','EM');
INSERT INTO factura VALUES (11529,'8125781-8','10456789-4',to_date('08/03/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),NULL,21900,4161,26061,NULL,1,NULL,'EM');
INSERT INTO factura Values (11530,'12444650-7','10456789-4',to_date('08/03/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),NULL,27000,5130,32130,NULL,1,NULL,'EM');

INSERT INTO factura VALUES(11531, NULL,'10456789-4', to_date('08/04/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)), NULL, 10000, 1900, 8100, NULL, 1,NULL, 'EM');
INSERT INTO factura VALUES(11532, NULL,'10712354-2', to_date('08/12/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)), NULL, 100000, 19000, 81000, 2, 1,NULL, 'EM');
INSERT INTO factura VALUES(11533, NULL,'10712354-2', TO_DATE('29/06/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)), NULL, 200000, 380000, 170000, NULL, 2,NULL, 'EM');
-- Agrega registros del año actual
INSERT INTO factura VALUES(11534, NULL,'10712354-2', To_Date('08/01/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE))), NULL, 10000, 1900, 8100, NULL, 1,NULL, 'EM');
INSERT INTO factura VALUES(11535, NULL,'10712354-2', TO_DATE('29/06/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE))), NULL, 100000, 19000, 81000, NULL, 1,NULL, 'EM');

INSERT INTO DETALLE_FACTURA VALUES (11520,1,25000,NULL,NULL,0,4,100000);
INSERT INTO DETALLE_FACTURA VALUES (11521,15,12900,NULL,NULL,0,10,129000);
INSERT INTO DETALLE_FACTURA VALUES (11521,19,2000,NULL,NULL,0,10,20000);
INSERT INTO DETALLE_FACTURA VALUES (11522,15,12900,NULL,NULL,0,10,129000);
INSERT INTO DETALLE_FACTURA VALUES (11522,16,6990,NULL,NULL,0,10,69900);
INSERT INTO DETALLE_FACTURA VALUES (11522,21,700,NULL,NULL,0,15,10500);
INSERT INTO DETALLE_FACTURA VALUES (11523,2,12500,NULL,NULL,0,3,37500);
INSERT INTO DETALLE_FACTURA VALUES (11524,3,12990,null,null,50,6,58455);
INSERT INTO DETALLE_FACTURA VALUES (11525,15,10000,null,null,50,4,30000);
INSERT INTO DETALLE_FACTURA VALUES (11526,5,4950,NULL,NULL,0,6,29700);
INSERT INTO DETALLE_FACTURA VALUES (11527,5,4950,NULL,NULL,0,6,29700);
INSERT INTO DETALLE_FACTURA VALUES (11528,5,4950,NULL,NULL,0,6,29700);
INSERT INTO DETALLE_FACTURA VALUES (11529,22,21900,null,null,0,1,21900);
INSERT INTO DETALLE_FACTURA VALUES (11530,24,27000,null,null,0,1,27000);

INSERT INTO DETALLE_FACTURA VALUES (11531,24,10000,null,null,0,1,10000);

INSERT INTO DETALLE_FACTURA VALUES (11532,24,10000,null,null,0,10,100000);
INSERT INTO DETALLE_FACTURA VALUES (11533,24,10000,null,null,0,20,200000);

INSERT INTO DETALLE_FACTURA VALUES (11534,24,10000,null,null,0,1,10000);
INSERT INTO DETALLE_FACTURA VALUES (11535,24,10000,null,null,0,10,100000);

insert into BOLETA values (120,'6245678-1','12456778-1',to_date('22/01/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),119000,1,4,'DS4344', 'EM');
insert into BOLETA values (121,'9912478-3','10712354-2',to_date('22/01/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),177310,NULL,1,NULL,'EM');
insert into BOLETA values (122,'14456789-4','12456778-1',to_date('23/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),249186,2,3,NULL,'PA');
insert into BOLETA values (123,'11245678-5','11124678-3',to_date('24/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),44625,NULL,1,NULL,'EM');
insert into BOLETA values (124,'6467708-6','11124678-3',to_date('25/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),69561,2,4,NULL,'EM');
insert into BOLETA values (125,'10125945-7','10456789-4',to_date('26/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),35700,2,4,'4865', 'EM');
insert into BOLETA values (126,'13746912-9','12456778-1',to_date('27/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),35343,2,3,NULL,'PA');
insert into BOLETA values (127,'10812874-0','10712354-2',to_date('17/03/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),35343,NULL,1,NULL,'EM');
insert into BOLETA values (128,'15123587-1','10456789-4',to_date('17/03/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),35343,2,4,'S/N 36147','EM');
insert into BOLETA values (129,NULL,'12456778-1',to_date('18/03/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),26061,NULL,1,NULL,'EM');
insert into BOLETA values (130,NULL,'10456789-4',to_date('18/03/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),32130,NULL,1,NULL,'EM');
insert into BOLETA values (131,'6245678-1','11124678-3',to_date('19/03/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),130900,1,4,'DS4344', 'EM');

INSERT INTO boleta VALUES(132, '6245678-1','11124678-3',to_date('19/04/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1)),780000,1,NULL,'DS4343', 'EM');

-- Agrega registros del año actual
insert into BOLETA values (133,'9912478-3','10712354-2',to_date('22/01/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE))),146500,NULL,1,NULL,'EM');
insert into BOLETA values (134,'14456789-4','12456778-1',to_date('23/02/'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE))),112500,2,3,NULL,'EM');

INSERT INTO DETALLE_BOLETA VALUES (120,1,25000,NULL,NULL,0,4,100000);
INSERT INTO DETALLE_BOLETA VALUES (121,15,12900,NULL,NULL,0,10,129000);
INSERT INTO DETALLE_BOLETA VALUES (121,19,2000,NULL,NULL,0,10,20000);
INSERT INTO DETALLE_BOLETA VALUES (122,15,12900,NULL,NULL,0,10,129000);
INSERT INTO DETALLE_BOLETA VALUES (122,16,6990,NULL,NULL,0,10,69900);
INSERT INTO DETALLE_BOLETA VALUES (122,21,700,NULL,NULL,0,15,10500);
INSERT INTO DETALLE_BOLETA VALUES (123,2,12500,NULL,NULL,0,3,37500);
INSERT INTO DETALLE_BOLETA VALUES (124,3,12990,null,null,50,6,58455);
INSERT INTO DETALLE_BOLETA VALUES (125,15,10000,null,null,50,4,30000);
INSERT INTO DETALLE_BOLETA VALUES (126,5,4950,NULL,NULL,0,6,29700);
INSERT INTO DETALLE_BOLETA VALUES (127,5,4950,NULL,NULL,0,6,29700);
INSERT INTO DETALLE_BOLETA VALUES (128,5,4950,NULL,NULL,0,6,29700);
INSERT INTO DETALLE_BOLETA VALUES (129,22,21900,null,null,0,1,21900);
INSERT INTO DETALLE_BOLETA VALUES (130,24,27000,null,null,0,1,27000);
INSERT INTO DETALLE_BOLETA VALUES (131,1,25000,NULL,NULL,0,4,100000);
INSERT INTO DETALLE_BOLETA VALUES (131,27,10000,NULL,NULL,0,1,10000);

INSERT INTO detalle_boleta VALUES(132,19,52000,NULL,NULL,0,15,780000);

INSERT INTO detalle_boleta VALUES(133,19, 52000, NULL, NULL, 0, 2, 104000);
INSERT INTO detalle_boleta VALUES(133,20, 42500, NULL, NULL, 0, 1, 42500);

INSERT INTO detalle_boleta VALUES(134,20, 42500, NULL, NULL, 0, 1, 42500);
INSERT INTO detalle_boleta VALUES(134,23, 35000, NULL, NULL, 0, 2, 70000);

INSERT INTO TRAMO_ANTIGUEDAD VALUES(1,1,9,4);
INSERT INTO TRAMO_ANTIGUEDAD VALUES(2,10,12,6);
INSERT INTO TRAMO_ANTIGUEDAD VALUES(3,13,16,7);
INSERT INTO TRAMO_ANTIGUEDAD VALUES(4,16,30,10);

INSERT INTO TRAMO_ESCOLARIDAD VALUES(10,'BA','BASICA',1);
INSERT INTO TRAMO_ESCOLARIDAD VALUES(20,'MCH','MEDIA CIENTIFICA HUMANISTA',2);
INSERT INTO TRAMO_ESCOLARIDAD VALUES(30,'MTP','MEDIA TECNICO PROFESIONAL',3);
INSERT INTO TRAMO_ESCOLARIDAD VALUES(40,'SCFT','SUPERIOR CENTRO DE FORMACION TECNICA',4);
INSERT INTO TRAMO_ESCOLARIDAD VALUES(50,'SIP','SUPERIOR INSTITUTO PROFESIONAL',5);
INSERT INTO TRAMO_ESCOLARIDAD VALUES(60,'SU','SUPERIOR UNIVERSIDAD',6);


CREATE TABLE producto_historico AS SELECT * FROM producto where procedencia='I';

UPDATE producto_historico
SET valorcompradolar= valorcompradolar * 1.1,
    vunitario = (valorcompradolar * 1.1) * 907.57
where procedencia='I';

insert into producto_historico values (32,'ZAPATO HOMBRE MODELO SPORT','UN','P',
				       58000, 45000, 79.88, 18,5,'I',2,NULL);

insert into producto_historico values (33,'ZAPATILLA DAMA MODELO WOMAN-1','UN','P',
				       38500, 25000, 49.18, 10,3,'I',2,NULL);

insert into producto_historico values (34,'ZAPATILLA VARON ADIDAS','UN','P',
				       95000, 59000, 105.73, 10,5,'I',2,NULL);




commit;