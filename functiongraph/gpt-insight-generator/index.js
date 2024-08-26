require('dotenv').config();
const { Configuration, OpenAIApi } = require('openai');
const axios = require('axios');

// Configuración de la API de OpenAI
const configuration = new Configuration({
    apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);

// Función principal para generar el insight
async function generateInsight(industry) {
    const prompt = `
    Generate an industry insight report for the ${industry} market in Chile. Include the following sections:
    1. Executive Summary
    2. Introduction
    3. Market Analysis
        3.1. General Overview
        3.2. Consumer Behavior
        3.3. Comparison with China
    4. Challenges and Opportunities
    5. Solutions and Recommendations
    6. Conclusion
    7. Sources and Methodology
    8. Appendices

    The report should also highlight how Huawei Cloud services can support the transformation of this industry. Provide specific examples of services such as Elastic Cloud Server (ECS), ModelArts, Data Lake Insight (DLI), and Cloud Security Services.
    `;

    try {
        const response = await openai.createCompletion({
            model: "text-davinci-003",
            prompt: prompt,
            max_tokens: 2048,
            temperature: 0.5,
        });

        return response.data.choices[0].text;
    } catch (error) {
        console.error("Error generating insight:", error);
        throw error;
    }
}

// Handler para Huawei Cloud FunctionGraph
module.exports.handler = async function (event, context) {
    const body = JSON.parse(event.body);
    const industry = body.industry || 'ecommerce';

    try {
        const insight = await generateInsight(industry);
        return {
            statusCode: 200,
            body: JSON.stringify({ insight }),
        };
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to generate insight' }),
        };
    }
};

// Si ejecutas el script localmente
if (require.main === module) {
    (async () => {
        const insight = await generateInsight('ecommerce');
        console.log(insight);
    })();
}