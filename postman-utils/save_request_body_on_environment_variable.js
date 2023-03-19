// salvar corpo do request em uma variavel de ambiente

// no pre-request
const request_body = pm.request.body.raw;

console.log(`Request Body: ${request_body}`);
pm.environment.set("request_body", request_body);

// body das outras requests: 
{{request_body}}
