--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: set_age(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_age() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN

        IF NEW.birthdate IS NULL THEN
            NEW.age:= NULL;
            RETURN NEW;
        END IF;

        NEW.age:= EXTRACT(year FROM age(current_date, NEW.birthdate));

        RETURN NEW;
    END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    price money DEFAULT 0 NOT NULL,
    owner integer NOT NULL,
    CONSTRAINT price_should_be_positive CHECK (((price)::numeric >= (0)::numeric))
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: user_id_sequence; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_id_sequence
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer DEFAULT nextval('public.user_id_sequence'::regclass) NOT NULL,
    name character varying(15) NOT NULL,
    balance money DEFAULT 0 NOT NULL,
    email character varying(50),
    birthdate date,
    age integer,
    CONSTRAINT users_birthdate_check CHECK ((birthdate < CURRENT_DATE))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (id, name, price, owner) FROM stdin;
1	PS5	$500.00	1
2	XBOX360	$150.00	2
4	PS4	$330.00	3
3	PS4	$320.00	1
5	iPhone XS	$700.00	10000
6	MacBook PRO	$1,350.00	10000
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, balance, email, birthdate, age) FROM stdin;
1	Ares	$100.00	\N	\N	\N
2	Test User 1	$200.00	\N	\N	\N
3	Test User 2	$500.00	\N	\N	\N
10000	Yuriy	$2,000.00	testuser@test.com	1997-10-23	22
\.


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_id_seq', 7, true);


--
-- Name: user_id_sequence; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_id_sequence', 10001, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users set_age; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_age BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_age();


--
-- Name: products products_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_owner_fkey FOREIGN KEY (owner) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

