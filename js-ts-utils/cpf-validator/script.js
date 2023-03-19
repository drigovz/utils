import ValidarCpf from './validar-cpf.js';

// selecionamos o elemento que é o CPF
const cpf = document.querySelector('#cpf');

const validarCpf = new ValidarCpf(cpf).initClass();

console.log(validarCpf);
// a saída será 
// {…}
// element: <input id="cpf" type="text" name="cpf" placeholder="000.000.000-00">
// <prototype>: Object { … }


