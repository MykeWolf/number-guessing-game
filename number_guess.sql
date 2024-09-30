--
-- PostgreSQL database dump
--

-- Dumped from database version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)
-- Dumped by pg_dump version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)

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

DROP DATABASE number_guess;
--
-- Name: number_guess; Type: DATABASE; Schema: -; Owner: freecodecamp
--

CREATE DATABASE number_guess WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE number_guess OWNER TO freecodecamp;

\connect number_guess

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: details; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.details (
    user_id integer NOT NULL,
    username character varying(22),
    games_played integer,
    best_game integer
);


ALTER TABLE public.details OWNER TO freecodecamp;

--
-- Name: details_user_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.details_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.details_user_id_seq OWNER TO freecodecamp;

--
-- Name: details_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.details_user_id_seq OWNED BY public.details.user_id;


--
-- Name: details user_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.details ALTER COLUMN user_id SET DEFAULT nextval('public.details_user_id_seq'::regclass);


--
-- Data for Name: details; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.details VALUES (29, 'Michael', 1, 14);
INSERT INTO public.details VALUES (31, 'user_1727703224996', 2, 113);
INSERT INTO public.details VALUES (30, 'user_1727703224997', 5, 82);
INSERT INTO public.details VALUES (33, 'user_1727703337938', 2, 198);
INSERT INTO public.details VALUES (32, 'user_1727703337939', 5, 49);


--
-- Name: details_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.details_user_id_seq', 33, true);


--
-- Name: details details_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.details
    ADD CONSTRAINT details_pkey PRIMARY KEY (user_id);


--
-- PostgreSQL database dump complete
--

