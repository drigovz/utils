// birthdate
function addYears(date, years) {
  const dateCopy = new Date(date);
  dateCopy.setFullYear(dateCopy.getFullYear() + years);
  return dateCopy;
}

const birthdate = addYears(Date.now(), -30).toISOString();
pm.variables.set("birth_date", birthdate);

// request body 
"birtdate": "{{birth_date}}",

