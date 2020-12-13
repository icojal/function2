async function main(params) {
  const { Client } = require('pg');

  const clientConfig = {
    host: process.env.POSTGRES_HOSTNAME || params.POSTGRES_HOSTNAME,
    port: process.env.POSTGRES_PORT || params.POSTGRES_PORT || 5432,
    user: process.env.POSTGRES_USERNAME || params.POSTGRES_USERNAME,
    password: process.env.POSTGRES_PASSWORD || params.POSTGRES_PASSWORD,
    database: process.env.POSTGRES_DATABASE || params.POSTGRES_DATABASE || 'postgres'
  };

  if( process.env.POSTGRES_BASE64_CERTIFICATE || params.POSTGRES_BASE64_CERTIFICATE ) {
    const cert_base64 = process.env.POSTGRES_BASE64_CERTIFICATE || params.POSTGRES_BASE64_CERTIFICATE;
    const caCert = Buffer.from(cert_base64, 'base64').toString('utf-8')
    clientConfig.ssl = { ca: caCert };
  }

  let response = { 
    headers: {
      "Access-Control-Allow-Headers" : "Content-Type",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET"
    }
  };

  try {
    const client = new Client(clientConfig);
    await client.connect();
    const { rows } = await client.query('SELECT id, detalle, estado, fecha_registro, fecha_actualizacion FROM public.solicitud');
    await client.end();
    return { ...response, statusCode: 200, body: JSON.stringify({ status: true, solicitudes: rows }) };
  } catch (error) {
    return { ...response, statusCode: 301, body: JSON.stringify({ status: false, error }) };
  }  
}

async function azure(context, req) {
  const response = await main(req);
  context.res = { ...response };
}

if( process.env.CLOUD_PROVIDER === 'AWS' ) {
  exports.handler = main;
} else {
  module.exports = azure;
}
