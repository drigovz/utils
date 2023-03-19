const days = 1;
const tomorrow = new Date(Date.now() + days * 24*60*60*1000).toISOString();
pm.variables.set("tomorrow_date", tomorrow);

// request body
"initialDate": "{{tomorrow_date}}",
