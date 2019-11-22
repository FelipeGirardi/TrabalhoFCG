#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
//in vec4 position_model;
//
//// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Cor gerada pela interpolação de Gouraud
in vec4 cor_v;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define SPHERE   0
#define ROMAN    1
#define PALM     2
#define STREET   3
#define BUILDING 4
#define PILLAR   5
uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D PalmTexture;
uniform sampler2D SunTexture;
uniform sampler2D StreetTexture;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec4 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    // Obtemos a posição da câmera utilizando a inversa da matriz que define o
    // sistema de coordenadas da câmera.
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // O fragmento atual é coberto por um ponto que percente à superfície de um
    // dos objetos virtuais da cena. Este ponto, p, possui uma posição no
    // sistema de coordenadas global (World coordinates). Esta posição é obtida
    // através da interpolação, feita pelo rasterizador, da posição de cada
    // vértice.
    vec4 p = position_world;

    // Normal do fragmento atual, interpolada pelo rasterizador a partir das
    // normais de cada vértice.
    vec4 n = normalize(normal);

    // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
    vec4 l = normalize(vec4(1.0f, 1.0f, -1.7f, 0.0f));

    // Vetor que define o sentido da câmera em relação ao ponto atual.
    vec4 v = normalize(camera_position - p);

    // Vetor que define o sentido da reflexão especular ideal.
    vec4 r = -l + 2 * n * (dot(n, l));

    // Parâmetros que definem as propriedades espectrais da superfície
    vec3 Kd; // Refletância difusa
    vec3 Ks; // Refletância especular
    vec3 Ka; // Refletância ambiente
    float q; // Expoente especular para o modelo de iluminação de Phong

    // Coordenadas de textura U e V
    float U = 0.0;
    float V = 0.0;

    // Variável auxiliar que guarda a cor final no formato vec3
    vec3 colorAux;

    if ( object_id == SPHERE )
    {
        // PREENCHA AQUI as coordenadas de textura da esfera, computadas com
        // projeção esférica EM COORDENADAS DO MODELO. Utilize como referência
        // o slide 144 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf".
        // A esfera que define a projeção deve estar centrada na posição
        // "bbox_center" definida abaixo.

        // Você deve utilizar:
        //   função 'length( )' : comprimento Euclidiano de um vetor
        //   função 'atan( , )' : arcotangente. Veja https://en.wikipedia.org/wiki/Atan2.
        //   função 'asin( )'   : seno inverso.
        //   constante M_PI
        //   variável position_model

//        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;
//        vec4 pVector = position_model - bbox_center;
//
//        float ro = length(pVector);
//        float theta = atan(pVector.x, pVector.z);
//        float phi = asin(pVector.y/ro);
//
//        U = (theta + M_PI) / (2 * M_PI);
//        V = (phi + (M_PI_2)) / M_PI;

        U = texcoords.x;
        V = texcoords.y;
    }
    else if ( object_id == ROMAN )
    {
        // PREENCHA AQUI as coordenadas de textura do coelho, computadas com
        // projeção planar XY em COORDENADAS DO MODELO. Utilize como referência
        // o slide 111 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf",
        // e também use as variáveis min*/max* definidas abaixo para normalizar
        // as coordenadas de textura U e V dentro do intervalo [0,1]. Para
        // tanto, veja por exemplo o mapeamento da variável 'p_v' utilizando
        // 'h' no slide 154 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf".
        // Veja também a Questão 4 do Questionário 4 no Moodle.

//        float minx = bbox_min.x;
//        float maxx = bbox_max.x;
//
//        float miny = bbox_min.y;
//        float maxy = bbox_max.y;
//
//        float minz = bbox_min.z;
//        float maxz = bbox_max.z;
//
//        U = (position_model.x - minx) / (maxx - minx);
//        V = (position_model.y - miny) / (maxy - miny);

        Kd = vec3(192.0f/255.0f,192.0f/255.0f,192.0f/255.0f);
        Ks = vec3(0.0,0.0,0.0);
        Ka = vec3(96.0f/255.0f,96.0f/255.0f,96.0f/255.0f);
        q = 128.0;
    }
    else if ( object_id == PALM )
    {
        U = texcoords.x;
        V = texcoords.y;
    }
    else if ( object_id == STREET )
    {
//        float minx = bbox_min.x;
//        float maxx = bbox_max.x;
//
//        float miny = bbox_min.y;
//        float maxy = bbox_max.y;
//
//        float minz = bbox_min.z;
//        float maxz = bbox_max.z;
//
//        U = (position_model.x - minx) / (maxx - minx);
//        V = (position_model.y - miny) / (maxy - miny);

        U = texcoords.x;
        V = texcoords.y;
    }
    else if ( object_id == BUILDING )
    {
        U = texcoords.x;
        V = texcoords.y;
    }
    else if ( object_id == PILLAR )
    {
//        U = texcoords.x;
//        V = texcoords.y;
    }

    // Obtemos a refletância difusa a partir da leitura das imagens
    vec3 Kd1 = texture(PalmTexture, vec2(U,V)).rgb;
    vec3 Kd2 = texture(SunTexture, vec2(U,V)).rgb;
    vec3 Kd3 = texture(StreetTexture, vec2(U,V)).rgb;

    // Espectro da fonte de iluminação
    vec3 I = vec3(1.0,1.0,1.0);

    // Espectro da luz ambiente
    vec3 Ia = vec3(0.2,0.2,0.2);

    // Equação de Iluminação
    float lambert = max(0,dot(n,l));

    if ( object_id == PALM ) {
        colorAux = Kd1 * (lambert + 0.01);
    }
    else if ( object_id == SPHERE ) {
        colorAux = Kd2; // * (lambert + 0.01);
    }
    else if ( object_id == STREET ) {
        colorAux = Kd3 * (lambert + 0.01);
    }
    else if ( object_id == ROMAN ) {
        // Termo difuso utilizando a lei dos cossenos de Lambert
        vec3 lambert_diffuse_term = Kd * I * lambert;
        // Termo ambiente
        vec3 ambient_term = Ka * Ia;
        // Vetor h (half-vector) para iluminação Blinn-Phong
        vec4 h = (v + l) / normalize(v + l);
        // Termo especular utilizando o modelo de iluminação de Blinn-Phong
        vec3 blinn_phong_specular_term  = Ks * I * pow(dot(n, h), q);
        //vec3 phong_specular_term  = Ks * I * pow(max(0, dot(r, v)), q);
        // Cor final do fragmento calculada com uma combinação dos termos difuso, ambiente e especular
        colorAux = lambert_diffuse_term + ambient_term + blinn_phong_specular_term;
    } else if ( object_id == PILLAR ) {
        colorAux = vec3(cor_v.x, cor_v.y, cor_v.z);
    }
    else {
        colorAux = vec3(1.0f, 1.0f, 1.0f) * (lambert + 0.01);
    }

    color = vec4(colorAux.x, colorAux.y, colorAux.z, 1.0f);
    // Cor final com correção gamma, considerando monitor sRGB.
    // Veja https://en.wikipedia.org/w/index.php?title=Gamma_correction&oldid=751281772#Windows.2C_Mac.2C_sRGB_and_TV.2Fvideo_standard_gammas
    color = pow(color, vec4(1.0,1.0,1.0,1.0)/2.2);
} 

