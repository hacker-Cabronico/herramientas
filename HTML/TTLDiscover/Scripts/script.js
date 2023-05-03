const ttlTable = {
    1: "Cisco IOS",
    32: "FreeBSD, Linux",
    56: "F5 Big-IP load balancer",
    60: "AIX",
    63: "Linux",
    64: "Linux, Unix",
    128: "Windows",
    254: "Solaris",
    255: "Cisco",
    256: "Cisco",
    257: "Cisco",
    512: "Cisco, Linux, Unix",
    999: "Not used",
    1024: "Not used",
    // Agrega aquí más valores de TTL y sistemas operativos asociados si lo deseas
};


const ttlForm = document.querySelector('#ttl-form');
const result = document.querySelector('#result');

ttlForm.addEventListener('submit', (event) => {
    event.preventDefault(); // Evita que el formulario se envíe
    const ttlInput = document.querySelector('#ttl-input').value;
    const system = ttlTable[ttlInput];
    if (system) {
        result.textContent = `El sistema operativo puede ser ${system}.`;
    } else {
        result.textContent = 'Valor TTL desconocido.';
    }
});