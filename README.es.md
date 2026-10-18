# Laboratorio de OWASP WebGoat con Docker Compose: lecciones guiadas de seguridad web, con WebWolf, en una copia privada

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-webgoat/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-webgoat/actions/workflows/check.yml)

Un **laboratorio de seguridad de aplicaciones web** listo para usar en clase, de la [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning), donde escuelas y centros dan a cada alumno sus propias bases de datos, contenedores y terminal en el navegador. Cada alumno recibe su propia copia de **OWASP WebGoat**, un recorrido guiado de lecciones que explican cada una una vulnerabilidad (inyección, control de acceso roto, deserialización insegura, errores de JWT, recorrido de rutas y más) y luego piden al alumno que la aproveche, con **WebWolf** al lado para las lecciones que necesitan una segunda parte. Sirve como primera introducción y para trabajo de casa, sin instalar nada y sin riesgo para el ordenador de nadie.

Es un único archivo `docker-compose`, `compose.yaml`, y funciona igual en tu propio ordenador que en la plataforma, donde cada alumno tiene una copia privada sin salida a Internet.

## La única regla

**Ataca tu propia copia y nada más.** Todo lo de este laboratorio se ejecuta dentro de tu copia privada, que no tiene ruta a Internet ni a ningún otro alumno, así que lo único que puedes alcanzar es la aplicación que el laboratorio ha iniciado para ti. No apuntes nunca una herramienta a un sitio web, una red o una máquina que no sean tuyos, ni en un laboratorio ni en ningún otro sitio: en el Reino Unido es un delito según la [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), y la mayoría de los países tienen una ley parecida. Aprender cómo funcionan las vulnerabilidades es la manera de crear software que no las tenga, y una buena primera conversación en clase es por qué existe esta regla y qué es la divulgación responsable.

## Qué incluye

| Servicio | Imagen | Memoria | Qué es |
| --- | --- | --- | --- |
| `webgoat` | [`webgoat/webgoat:v2026.5`](https://hub.docker.com/r/webgoat/webgoat) | 1 GB | WebGoat y WebWolf, aplicaciones Java, que se ejecutan con una cuenta sin privilegios (1001) y sin ninguna capacidad |
| `web` | [`nginx:1.27-alpine`](https://hub.docker.com/_/nginx) | 64 MB | un pequeño proxy por delante |

El proxy está por una sola razón: WebGoat responde 404 en `/` y vive en `/WebGoat`, así que el enlace del laboratorio abriría una página de error. Envía `/` a `/WebGoat/` y deja pasar todo lo demás con la dirección propia del navegador. WebGoat recibe un gigabyte, el que más de los tres laboratorios de seguridad, porque es una aplicación Java; arranca en unos siete segundos y usa más o menos 450 MB con poco uso.

Las imágenes son programas de terceros, ejecutados sin modificar a partir de las imágenes públicas de los propios proyectos y fijadas a una versión (nunca `latest`), de modo que el laboratorio no cambia a mitad de curso entre una lección y la siguiente. Aquí no se construye nada y nada de este repositorio se distribuye en ellas.

## Usarlo en la plataforma

La [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning) da a cada alumno su propia copia de un laboratorio, en el navegador, con un terminal al lado.

**Para probarlo:** abre la [página de contenedores](https://mitsurutech.co.uk/es/container), busca este laboratorio en **Laboratorios de ejemplo** y pulsa Iniciar. No hace falta una cuenta para probar uno.

**Para ponerlo como trabajo a una clase:**

1. En tu módulo, crea una tarea de tipo **Laboratorio** y elige **En un repositorio de GitHub**.
2. Indica `https://github.com/mitsurutech/lab-webgoat` con la rama `main`. El archivo compose es el predeterminado, `compose.yaml`. Haz antes un fork del repositorio si quieres cambiar el archivo.
3. Publica. La copia de cada alumno parte del commit que publicaste, así que un cambio posterior aquí no altera un laboratorio ya asignado.
4. Indica en la tarea qué hay que entregar (consulta [Para profesores](#para-profesores)) y asígnala como cualquier otra tarea.

La [guía de los laboratorios de seguridad](https://mitsurutech.co.uk/es/help/security-labs) del manual y su [guía de los laboratorios de contenedores](https://mitsurutech.co.uk/es/help/labs) explican el resto: qué puede decir un archivo compose, cuánta memoria recibe una copia y cómo abre, vigila y califica un profesor la copia de un alumno.

¿Todavía no tienes una cuenta de centro? [El primer año es gratis](https://mitsurutech.co.uk/es/pricing) para hasta 50 alumnos, y [registrarse](https://mitsurutech.co.uk/es/signup) solo requiere una dirección de correo electrónico.

## Ejecutarlo en tu propio ordenador

Necesitas Docker con el complemento Compose. El primer inicio descarga las imágenes.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Abre <http://localhost:8080/WebGoat> para WebGoat y <http://localhost:9090/WebWolf> para WebWolf.

`local.yaml` publica los puertos solo en `127.0.0.1`, de modo que el laboratorio se alcanza desde tu ordenador y desde ningún otro sitio. Páralo con `Ctrl-C` y elimínalo con `docker compose -f compose.yaml -f local.yaml down -v`. Ejecútalo en una máquina desde la que no te importe atacar: la aplicación es insegura a propósito.

## Cómo trabajarlo

1. **Regístrate.** Abre WebGoat, elige **Register** e inventa un nombre de usuario y una contraseña para esta copia.
2. **Empieza por lo más alto de la lista de lecciones.** Cada lección explica una vulnerabilidad, como la inyección, el control de acceso roto, la deserialización insegura, los errores de JWT o el recorrido de rutas, y luego te pide que la aproveches. La lección se marca como completada cuando lo consigues.
3. **Usa WebWolf cuando una lección lo diga.** El laboratorio tiene dos enlaces, WebGoat y WebWolf, y WebWolf es para las lecciones que necesitan una segunda parte, como una que te envía un mensaje. Inicia sesión allí con la misma cuenta.
4. **Tu progreso dura mientras el laboratorio está en marcha.** No se conserva cuando se detiene.

## Para profesores

Nada de este laboratorio se califica automáticamente. El alumno entrega pruebas y tú las calificas, como cualquier otro laboratorio.

**Pide las pruebas en dos mitades.** Primero, la prueba del trabajo: una captura de pantalla de cada lección marcada como completada, con la dirección propia del laboratorio visible en el navegador para que quede claro que es su copia. Segundo, la comprensión: para cada una, una explicación escrita con sus propias palabras de qué es la vulnerabilidad, la entrada exacta que usó y por qué funcionó, qué podría hacer un atacante con ella y cómo debería haberse escrito el código. La segunda mitad te dice si se entendió o se copió de una guía paso a paso. Para un trabajo más sólido, pide la corrección además del ataque.

**Dónde encaja en un curso.** WebGoat sirve como primera introducción a cada clase de vulnerabilidad con la explicación al lado, y para los fundamentos de criptografía, tokens y deserialización. También apoya la parte legal y ética de una unidad: autorización y alcance, la Computer Misuse Act 1990 y la divulgación responsable. Consulta la unidad de tu propio organismo certificador para ver la redacción exacta: aquí no se cita ninguna.

**Quién ve qué.** Estos laboratorios se usan a menudo con alumnos de 16 y 17 años. Una copia es privada para el alumno que la inició. Un miembro del personal que da clase en el módulo puede abrirla para ver lo que ha hecho el alumno, y abrir el trabajo de un alumno queda anotado en el registro de accesos, que el alumno puede leer.

## Lo que no funciona en un laboratorio

El progreso de WebGoat solo dura mientras el laboratorio está en marcha. El laboratorio no tiene salida a Internet, así que una lección que necesite un sitio de Internet no se puede completar. WebGoat es una aplicación Java y recibe 1 GB, el que más de los tres laboratorios de seguridad, y tarda unos segundos más en arrancar que los otros.

## Solución de problemas

- **La página de inicio de sesión no aparece justo después de Iniciar.** Espera unos segundos y pulsa Abrir otra vez: el laboratorio solo se declara listo cuando WebGoat responde a través de su proxy.
- **El segundo enlace, WebWolf, no te inicia sesión.** Regístrate primero en WebGoat y luego inicia sesión en WebWolf con la misma cuenta.
- **En tu ordenador, el puerto 8080 o el 9090 ya está en uso.** Cambia los números de la izquierda en `local.yaml` y abre esos puertos en su lugar.

## Comprobar el laboratorio

`test/check.sh` inicia el laboratorio como el ejecutor de la plataforma inicia cada servicio (todas las capacidades retiradas, `no-new-privileges`, un límite de procesos, límites de memoria y sin salida a Internet) y luego comprueba desde dentro de su red lo que promete esta página. Necesita Docker y se ejecuta en cada push, que es la insignia de arriba.

```bash
test/check.sh
```

## Versiones y licencias de terceros

[WebGoat](https://github.com/WebGoat/WebGoat) tiene licencia GPL-2.0 y [nginx](https://nginx.org) BSD-2-Clause. Las imágenes son `webgoat/webgoat:v2026.5` y `nginx:1.27-alpine`.

## Licencia

Esta obra está bajo licencia [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Puedes compartirla y adaptarla para aprender y enseñar, si citas a Mitsuru Technologies Ltd, no la usas comercialmente y compartes lo que hagas con ella bajo la misma licencia. El texto completo está en el archivo `LICENSE`. Cubre el archivo compose, las pruebas y esta documentación. La aplicación que contiene conserva la licencia de su propio proyecto, enlazada arriba.

## Acerca de

Creado por [Mitsuru Technologies](https://mitsurutech.co.uk) para la [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning): Python, Java, Go, Node, SQL y Linux en el navegador para escuelas y centros, con laboratorios de contenedores, aplicaciones web desplegadas desde GitHub y cuestionarios que se califican solos. Prueba código sin cuenta en el [entorno de pruebas](https://mitsurutech.co.uk/es/playground).

Más laboratorios del mismo sitio: [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) y [lab-sample](https://github.com/mitsurutech/lab-sample).
