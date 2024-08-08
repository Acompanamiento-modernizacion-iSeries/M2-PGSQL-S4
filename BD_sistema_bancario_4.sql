--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3


--
-- TOC entry 215 (class 1259 OID 17203)
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    cliente_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    direccion text,
    telefono character varying(20),
    correo_electronico character varying(100),
    fecha_nacimiento date,
    estado character varying(20),
    sucursal_id integer,
    CONSTRAINT clientes_estado_check CHECK (((estado)::text = ANY (ARRAY[('activo'::character varying)::text, ('inactivo'::character varying)::text])))
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17209)
-- Name: clientes_cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_cliente_id_seq OWNER TO postgres;

--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 216
-- Name: clientes_cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_cliente_id_seq OWNED BY public.clientes.cliente_id;


--
-- TOC entry 217 (class 1259 OID 17210)
-- Name: cuentas_bancarias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuentas_bancarias (
    cuenta_id integer NOT NULL,
    cliente_id integer,
    numero_cuenta character varying(50) NOT NULL,
    tipo_cuenta character varying(20),
    saldo numeric(15,2) DEFAULT 0.00,
    fecha_apertura date,
    estado character varying(20),
    sucursal_id integer,
    CONSTRAINT cuentas_bancarias_estado_check CHECK (((estado)::text = ANY (ARRAY[('activa'::character varying)::text, ('cerrada'::character varying)::text]))),
    CONSTRAINT cuentas_bancarias_tipo_cuenta_check CHECK (((tipo_cuenta)::text = ANY (ARRAY[('corriente'::character varying)::text, ('ahorro'::character varying)::text])))
);


ALTER TABLE public.cuentas_bancarias OWNER TO postgres;


--
-- TOC entry 232 (class 1259 OID 17253)
-- Name: transacciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transacciones (
    transaccion_id integer NOT NULL,
    cuenta_id integer,
    tipo_transaccion character varying(20),
    monto numeric(15,2),
    fecha_transaccion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    descripcion text,
    CONSTRAINT transacciones_tipo_transaccion_check CHECK (((tipo_transaccion)::text = ANY (ARRAY[('depósito'::character varying)::text, ('retiro'::character varying)::text, ('transferencia'::character varying)::text])))
);


ALTER TABLE public.transacciones OWNER TO postgres;


--
-- TOC entry 218 (class 1259 OID 17216)
-- Name: cuentas_bancarias_cuenta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuentas_bancarias_cuenta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cuentas_bancarias_cuenta_id_seq OWNER TO postgres;

--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 218
-- Name: cuentas_bancarias_cuenta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cuentas_bancarias_cuenta_id_seq OWNED BY public.cuentas_bancarias.cuenta_id;



--
-- TOC entry 219 (class 1259 OID 17217)
-- Name: departamentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departamentos (
    departamento_id integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE public.departamentos OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17220)
-- Name: departamentos_departamento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departamentos_departamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departamentos_departamento_id_seq OWNER TO postgres;

--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 220
-- Name: departamentos_departamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departamentos_departamento_id_seq OWNED BY public.departamentos.departamento_id;


--
-- TOC entry 221 (class 1259 OID 17221)
-- Name: empleados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleados (
    empleado_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    direccion text,
    telefono character varying(20),
    correo_electronico character varying(100),
    fecha_contratacion date,
    posicion character varying(100),
    salario numeric(15,2),
    sucursal_id integer,
    departamento_id integer
);


ALTER TABLE public.empleados OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17226)
-- Name: empleados_empleado_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.empleados_empleado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.empleados_empleado_id_seq OWNER TO postgres;

--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 222
-- Name: empleados_empleado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.empleados_empleado_id_seq OWNED BY public.empleados.empleado_id;


--
-- TOC entry 223 (class 1259 OID 17227)
-- Name: prestamos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prestamos (
    prestamo_id integer NOT NULL,
    cuenta_id integer,
    monto numeric(15,2),
    tasa_interes numeric(5,2),
    fecha_inicio date,
    fecha_fin date,
    estado character varying(20),
    CONSTRAINT prestamos_estado_check CHECK (((estado)::text = ANY (ARRAY[('activo'::character varying)::text, ('pagado'::character varying)::text])))
);


ALTER TABLE public.prestamos OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17231)
-- Name: prestamos_prestamo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prestamos_prestamo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prestamos_prestamo_id_seq OWNER TO postgres;

--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 224
-- Name: prestamos_prestamo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prestamos_prestamo_id_seq OWNED BY public.prestamos.prestamo_id;



--
-- TOC entry 225 (class 1259 OID 17232)
-- Name: productos_financieros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos_financieros (
    producto_id integer NOT NULL,
    nombre_producto character varying(100) NOT NULL,
    tipo_producto character varying(50),
    descripcion text,
    tasa_interes numeric(5,2),
    CONSTRAINT productos_financieros_tipo_producto_check CHECK (((tipo_producto)::text = ANY (ARRAY[('préstamo'::character varying)::text, ('tarjeta de crédito'::character varying)::text, ('seguro'::character varying)::text])))
);


ALTER TABLE public.productos_financieros OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17238)
-- Name: productos_financieros_producto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productos_financieros_producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productos_financieros_producto_id_seq OWNER TO postgres;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 226
-- Name: productos_financieros_producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_financieros_producto_id_seq OWNED BY public.productos_financieros.producto_id;


--
-- TOC entry 227 (class 1259 OID 17239)
-- Name: relacion_clientes_productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relacion_clientes_productos (
    cliente_id integer NOT NULL,
    producto_id integer NOT NULL,
    fecha_adquisicion date
);


ALTER TABLE public.relacion_clientes_productos OWNER TO postgres;


--
-- TOC entry 228 (class 1259 OID 17242)
-- Name: sucursales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sucursales (
    sucursal_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    direccion text,
    telefono character varying(20)
);


ALTER TABLE public.sucursales OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17247)
-- Name: sucursales_sucursal_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sucursales_sucursal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sucursales_sucursal_id_seq OWNER TO postgres;

--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 229
-- Name: sucursales_sucursal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sucursales_sucursal_id_seq OWNED BY public.sucursales.sucursal_id;



--
-- TOC entry 230 (class 1259 OID 17248)
-- Name: tarjetas_credito; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarjetas_credito (
    tarjeta_id integer NOT NULL,
    cuenta_id integer,
    numero_tarjeta character varying(50) NOT NULL,
    limite_credito numeric(15,2),
    saldo_actual numeric(15,2),
    fecha_emision date,
    fecha_vencimiento date,
    estado character varying(20),
    CONSTRAINT tarjetas_credito_estado_check CHECK (((estado)::text = ANY (ARRAY[('activa'::character varying)::text, ('bloqueada'::character varying)::text])))
);


ALTER TABLE public.tarjetas_credito OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17252)
-- Name: tarjetas_credito_tarjeta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tarjetas_credito_tarjeta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tarjetas_credito_tarjeta_id_seq OWNER TO postgres;

--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 231
-- Name: tarjetas_credito_tarjeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tarjetas_credito_tarjeta_id_seq OWNED BY public.tarjetas_credito.tarjeta_id;


--
-- TOC entry 233 (class 1259 OID 17260)
-- Name: transacciones_transaccion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transacciones_transaccion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transacciones_transaccion_id_seq OWNER TO postgres;

--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 233
-- Name: transacciones_transaccion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transacciones_transaccion_id_seq OWNED BY public.transacciones.transaccion_id;


--
-- TOC entry 4772 (class 2604 OID 17261)
-- Name: clientes cliente_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN cliente_id SET DEFAULT nextval('public.clientes_cliente_id_seq'::regclass);


--
-- TOC entry 4773 (class 2604 OID 17262)
-- Name: cuentas_bancarias cuenta_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuentas_bancarias ALTER COLUMN cuenta_id SET DEFAULT nextval('public.cuentas_bancarias_cuenta_id_seq'::regclass);


--
-- TOC entry 4775 (class 2604 OID 17263)
-- Name: departamentos departamento_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamentos ALTER COLUMN departamento_id SET DEFAULT nextval('public.departamentos_departamento_id_seq'::regclass);


--
-- TOC entry 4776 (class 2604 OID 17264)
-- Name: empleados empleado_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados ALTER COLUMN empleado_id SET DEFAULT nextval('public.empleados_empleado_id_seq'::regclass);


--
-- TOC entry 4777 (class 2604 OID 17265)
-- Name: prestamos prestamo_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos ALTER COLUMN prestamo_id SET DEFAULT nextval('public.prestamos_prestamo_id_seq'::regclass);


--
-- TOC entry 4778 (class 2604 OID 17266)
-- Name: productos_financieros producto_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos_financieros ALTER COLUMN producto_id SET DEFAULT nextval('public.productos_financieros_producto_id_seq'::regclass);


--
-- TOC entry 4779 (class 2604 OID 17267)
-- Name: sucursales sucursal_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursales ALTER COLUMN sucursal_id SET DEFAULT nextval('public.sucursales_sucursal_id_seq'::regclass);


--
-- TOC entry 4780 (class 2604 OID 17268)
-- Name: tarjetas_credito tarjeta_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarjetas_credito ALTER COLUMN tarjeta_id SET DEFAULT nextval('public.tarjetas_credito_tarjeta_id_seq'::regclass);


--
-- TOC entry 4781 (class 2604 OID 17269)
-- Name: transacciones transaccion_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transacciones ALTER COLUMN transaccion_id SET DEFAULT nextval('public.transacciones_transaccion_id_seq'::regclass);



--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 216
-- Name: clientes_cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_cliente_id_seq', 1, false);


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 218
-- Name: cuentas_bancarias_cuenta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuentas_bancarias_cuenta_id_seq', 1, false);


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 220
-- Name: departamentos_departamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departamentos_departamento_id_seq', 1, false);


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 222
-- Name: empleados_empleado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empleados_empleado_id_seq', 1, false);


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 224
-- Name: prestamos_prestamo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prestamos_prestamo_id_seq', 1, false);


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 226
-- Name: productos_financieros_producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_financieros_producto_id_seq', 1, false);


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 229
-- Name: sucursales_sucursal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sucursales_sucursal_id_seq', 1, false);


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 231
-- Name: tarjetas_credito_tarjeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarjetas_credito_tarjeta_id_seq', 1, false);


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 233
-- Name: transacciones_transaccion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transacciones_transaccion_id_seq', 1, false);


--
-- TOC entry 4791 (class 2606 OID 17271)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (cliente_id);


--
-- TOC entry 4793 (class 2606 OID 17273)
-- Name: cuentas_bancarias cuentas_bancarias_numero_cuenta_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuentas_bancarias
    ADD CONSTRAINT cuentas_bancarias_numero_cuenta_key UNIQUE (numero_cuenta);


--
-- TOC entry 4795 (class 2606 OID 17275)
-- Name: cuentas_bancarias cuentas_bancarias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuentas_bancarias
    ADD CONSTRAINT cuentas_bancarias_pkey PRIMARY KEY (cuenta_id);


--
-- TOC entry 4797 (class 2606 OID 17277)
-- Name: departamentos departamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamentos
    ADD CONSTRAINT departamentos_pkey PRIMARY KEY (departamento_id);


--
-- TOC entry 4799 (class 2606 OID 17279)
-- Name: empleados empleados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT empleados_pkey PRIMARY KEY (empleado_id);


--
-- TOC entry 4801 (class 2606 OID 17281)
-- Name: prestamos prestamos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_pkey PRIMARY KEY (prestamo_id);


--
-- TOC entry 4803 (class 2606 OID 17283)
-- Name: productos_financieros productos_financieros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos_financieros
    ADD CONSTRAINT productos_financieros_pkey PRIMARY KEY (producto_id);


--
-- TOC entry 4805 (class 2606 OID 17285)
-- Name: relacion_clientes_productos relacion_clientes_productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relacion_clientes_productos
    ADD CONSTRAINT relacion_clientes_productos_pkey PRIMARY KEY (cliente_id, producto_id);


--
-- TOC entry 4807 (class 2606 OID 17287)
-- Name: sucursales sucursales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursales
    ADD CONSTRAINT sucursales_pkey PRIMARY KEY (sucursal_id);


--
-- TOC entry 4809 (class 2606 OID 17289)
-- Name: tarjetas_credito tarjetas_credito_numero_tarjeta_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarjetas_credito
    ADD CONSTRAINT tarjetas_credito_numero_tarjeta_key UNIQUE (numero_tarjeta);


--
-- TOC entry 4811 (class 2606 OID 17291)
-- Name: tarjetas_credito tarjetas_credito_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarjetas_credito
    ADD CONSTRAINT tarjetas_credito_pkey PRIMARY KEY (tarjeta_id);


--
-- TOC entry 4813 (class 2606 OID 17293)
-- Name: transacciones transacciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transacciones
    ADD CONSTRAINT transacciones_pkey PRIMARY KEY (transaccion_id);


--
-- TOC entry 4815 (class 2606 OID 17294)
-- Name: cuentas_bancarias cuentas_bancarias_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuentas_bancarias
    ADD CONSTRAINT cuentas_bancarias_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(cliente_id);


--
-- TOC entry 4817 (class 2606 OID 17299)
-- Name: empleados empleados_departamento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT empleados_departamento_id_fkey FOREIGN KEY (departamento_id) REFERENCES public.departamentos(departamento_id);


--
-- TOC entry 4818 (class 2606 OID 17304)
-- Name: empleados empleados_sucursal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT empleados_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES public.sucursales(sucursal_id);


--
-- TOC entry 4814 (class 2606 OID 17602)
-- Name: clientes fk_sucursal; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT fk_sucursal FOREIGN KEY (sucursal_id) REFERENCES public.sucursales(sucursal_id);


--
-- TOC entry 4816 (class 2606 OID 17620)
-- Name: cuentas_bancarias fk_sucursal; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuentas_bancarias
    ADD CONSTRAINT fk_sucursal FOREIGN KEY (sucursal_id) REFERENCES public.sucursales(sucursal_id);


--
-- TOC entry 4819 (class 2606 OID 17309)
-- Name: prestamos prestamos_cuenta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_cuenta_id_fkey FOREIGN KEY (cuenta_id) REFERENCES public.cuentas_bancarias(cuenta_id);


--
-- TOC entry 4820 (class 2606 OID 17314)
-- Name: relacion_clientes_productos relacion_clientes_productos_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relacion_clientes_productos
    ADD CONSTRAINT relacion_clientes_productos_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(cliente_id);


--
-- TOC entry 4821 (class 2606 OID 17319)
-- Name: relacion_clientes_productos relacion_clientes_productos_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relacion_clientes_productos
    ADD CONSTRAINT relacion_clientes_productos_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos_financieros(producto_id);


--
-- TOC entry 4822 (class 2606 OID 17324)
-- Name: tarjetas_credito tarjetas_credito_cuenta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarjetas_credito
    ADD CONSTRAINT tarjetas_credito_cuenta_id_fkey FOREIGN KEY (cuenta_id) REFERENCES public.cuentas_bancarias(cuenta_id);


--
-- TOC entry 4823 (class 2606 OID 17329)
-- Name: transacciones transacciones_cuenta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transacciones
    ADD CONSTRAINT transacciones_cuenta_id_fkey FOREIGN KEY (cuenta_id) REFERENCES public.cuentas_bancarias(cuenta_id);


-- Completed on 2024-08-08 13:24:06

--
-- PostgreSQL database dump complete
--

--
-- Inserts De todas las Tablas
--

INSERT INTO public.sucursales (sucursal_id, nombre, direccion, telefono) VALUES
(1, 'Sucursal Central', 'Calle Principal 100', '555-0000'),
(2, 'Sucursal Norte', 'Avenida Norte 200', '555-1111'),
(3, 'Sucursal Sur', 'Calle Sur 300', '555-2222'),
(4, 'Sucursal Este', 'Boulevard Este 400', '555-3333'),
(5, 'Sucursal New York', '123 New York Avenue, New York, NY', '123-456-7890');

INSERT INTO public.clientes (cliente_id, nombre, apellido, direccion, telefono, correo_electronico, fecha_nacimiento, estado, sucursal_id) VALUES
(1, 'Juan', 'Pérez', 'Calle 123', '555-1234', 'juan.perez@clientes.com', '1980-01-15', 'activo', 1),
(2, 'María', 'López', 'Avenida 456', '555-5678', 'maria.lopez@clientes.com', '1990-02-25', 'activo', 2),
(3, 'Carlos', 'Gómez', 'Calle 789', '555-8765', 'carlos.gomez@clientes.com', '1975-03-30', 'inactivo', 3),
(4, 'Ana', 'Rodríguez', 'Boulevard 101', '555-4321', 'ana.rodriguez@clientes.com', '1985-04-20', 'activo', 4),
(7, 'Alice', 'Johnson', '101 Oak Street', '555-1234', 'alice.johnson@example.com', '1985-01-20', 'activo', 5),
(8, 'Bob', 'Smith', '202 Pine Street', '555-5678', 'bob.smith@example.com', '1990-05-15', 'activo', 5);

INSERT INTO public.cuentas_bancarias (cuenta_id, cliente_id, numero_cuenta, tipo_cuenta, saldo, fecha_apertura, estado, sucursal_id) VALUES
(1, 1, '1234567890', 'corriente', 10000.00, '2021-05-15', 'activa', 1),
(2, 2, '2345678901', 'ahorro', 15000.00, '2022-06-20', 'activa', 2),
(3, 3, '3456789012', 'corriente', 5000.00, '2023-07-25', 'cerrada', 3),
(4, 4, '4567890123', 'ahorro', 2000.00, '2020-08-30', 'activa', 4),
(6, 1, '1017246600', 'ahorro', 2000.00, '2022-01-10', 'activa', 1),
(7, 2, '0987654321', 'corriente', 50.00, '2023-01-10', 'activa', 2),
(8, 7, '0987654311', 'corriente', 5000.00, '2023-01-10', 'activa', 5),
(9, 8, '0987654211', 'ahorro', 50000.00, '2023-01-10', 'activa', 5),
(10, 1, '1987654311', 'corriente', 5000.00, '2024-08-01', 'activa', 2),
(11, 2, '1957654311', 'ahorro', 50000.00, '2024-08-01', 'activa', 1);


INSERT INTO public.departamentos (departamento_id, nombre) VALUES
(1, 'Recursos Humanos'),
(2, 'Finanzas'),
(3, 'IT'),
(4, 'Marketing'),
(5, 'HR'),
(6, 'Finance');


INSERT INTO public.empleados (empleado_id, nombre, apellido, direccion, telefono, correo_electronico, fecha_contratacion, posicion, salario, sucursal_id, departamento_id) VALUES
(1, 'Pedro', 'Martínez', 'Calle Alfa 1', '555-4444', 'pedro.martinez@empleados.com', '2015-06-15', 'Cajero', 30000.00, 1, 1),
(5, 'John', 'Doe', '456 Elm Street', '555-1234', 'john.doe@example.com', '2020-01-15', 'Manager', 75000.00, 1, 1),
(2, 'Lucía', 'García', 'Avenida Beta 2', '555-5555', 'lucia.garcia@empleados.com', '2018-09-20', 'Asistente', 35000.00, 2, 2),
(7, 'Alice', 'Johnson', '101 Oak Street', '555-8765', 'alice.johnson@example.com', '2021-03-10', 'Designer', 70000.00, 2, 2),
(3, 'Miguel', 'Sánchez', 'Calle Gamma 3', '555-6666', 'miguel.sanchez@empleados.com', '2020-01-10', 'Gerente', 50000.00, 3, 3),
(8, 'Bob', 'Brown', '202 Pine Street', '555-4321', 'bob.brown@example.com', '2018-08-30', 'Analyst', 62000.00, 3, 3),
(4, 'Elena', 'Ruiz', 'Boulevard Delta 4', '555-7777', 'elena.ruiz@empleados.com', '2017-11-25', 'Contador', 40000.00, 4, 4),
(6, 'Jane', 'Smith', '789 Maple Avenue', '555-5678', 'jane.smith@example.com', '2019-06-22', 'Developer', 65000.00, NULL, 5);


INSERT INTO public.prestamos (prestamo_id, cuenta_id, monto, tasa_interes, fecha_inicio, fecha_fin, estado) VALUES
(1, 1, 5000.00, 5.00, '2023-01-01', '2025-01-01', 'activo'),
(2, 2, 10000.00, 4.50, '2022-02-01', '2026-02-01', 'activo'),
(3, 3, 7000.00, 5.00, '2021-03-01', '2025-03-01', 'pagado'),
(4, 4, 8000.00, 4.00, '2020-04-01', '2024-04-01', 'activo');


INSERT INTO public.productos_financieros (producto_id, nombre_producto, tipo_producto, descripcion, tasa_interes) VALUES
(1, 'Préstamo Personal', 'préstamo', 'Préstamo para necesidades personales', 5.00),
(2, 'Tarjeta de Crédito Oro', 'tarjeta de crédito', 'Tarjeta de crédito con beneficios premium', 2.50),
(3, 'Seguro de Vida', 'seguro', 'Seguro de vida completo', NULL),
(4, 'Préstamo Hipotecario', 'préstamo', 'Préstamo para compra de vivienda', 4.00);

INSERT INTO public.relacion_clientes_productos (cliente_id, producto_id, fecha_adquisicion) VALUES
(1, 1, '2023-01-01'),
(2, 2, '2022-02-01'),
(3, 3, '2021-03-01'),
(4, 4, '2020-04-01');


INSERT INTO public.tarjetas_credito (tarjeta_id, cuenta_id, numero_tarjeta, limite_credito, saldo_actual, fecha_emision, fecha_vencimiento, estado) VALUES
(1, 1, '1111222233334444', 10000.00, 2000.00, '2023-05-15', '2027-05-15', 'activa'),
(2, 2, '5555666677778888', 15000.00, 5000.00, '2022-06-20', '2026-06-20', 'activa'),
(3, 3, '9999000011112222', 20000.00, 10000.00, '2021-07-25', '2025-07-25', 'bloqueada'),
(4, 4, '3333444455556666', 5000.00, 1000.00, '2020-08-30', '2024-08-30', 'activa');


INSERT INTO public.transacciones (transaccion_id, cuenta_id, tipo_transaccion, monto, fecha_transaccion, descripcion) VALUES
(1, 1, 'depósito', 1000.00, '2024-01-01 10:00:00', 'Depósito inicial'),
(2, 2, 'retiro', 500.00, '2024-02-01 11:00:00', 'Retiro de efectivo'),
(3, 3, 'transferencia', 2000.00, '2024-03-01 12:00:00', 'Transferencia a otra cuenta'),
(4, 4, 'depósito', 3000.00, '2024-04-01 13:00:00', 'Depósito de salario'),
(5, 1, 'depósito', 1500.00, '2024-01-15 10:00:00', 'Depósito inicial'),
(6, 2, 'retiro', 75.00, '2024-02-20 14:00:00', 'Compra en tienda'),
(7, 2, 'transferencia', 50.00, '2024-03-05 09:30:00', 'Transferencia a ahorros'),
(8, 1, 'depósito', 1500.00, '2024-07-15 00:00:00', 'Depósito en efectivo'),
(9, 2, 'retiro', 500.00, '2024-07-20 00:00:00', 'Retiro de cajero automático'),
(10, 3, 'transferencia', 300.00, '2024-07-25 00:00:00', 'Transferencia a cuenta de ahorros'),
(11, 4, 'depósito', 2500.00, '2024-08-01 00:00:00', 'Depósito por transferencia bancaria'),
(12, 4, 'retiro', 200.00, '2024-08-05 00:00:00', 'Retiro en ventanilla'),
(13, 3, 'transferencia', 1200.00, '2024-06-01 00:00:00', 'Transferencia a otra cuenta'),
(14, 2, 'depósito', 800.00, '2024-07-10 00:00:00', 'Depósito en efectivo'),
(15, 1, 'retiro', 400.00, '2024-07-30 00:00:00', 'Retiro de cajero automático'),
(16, 1, 'transferencia', 600.00, '2024-08-03 00:00:00', 'Transferencia a cuenta de ahorros'),
(17, 2, 'depósito', 1000.00, '2024-08-04 00:00:00', 'Depósito en efectivo'),
(18, 2, 'depósito', 10.00, '2024-08-04 00:00:00', 'Depósito en efectivo'),
(19, 1, 'transferencia', 300.00, '2024-07-25 00:00:00', 'Transferencia a cuenta de ahorros'),
(20, 4, 'retiro', 2000.00, '2024-02-20 14:00:00', 'Compra en tienda');
