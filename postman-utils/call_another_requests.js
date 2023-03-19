// Pre-requests chamando outras requests:

const result = {
    url: `url_another_endpoint`,
    method: 'POST',
    header: {
        'content-type': 'application/json',
    },
    body: {
        mode: 'raw',
        raw: JSON.stringify(
        {
            userName: 'user_name',
            password: 'password'
        })
    }
};

pm.sendRequest(result, (err, response) => {
    var data = response.json();
    pm.variables.set("token", data.token);
});

// na aba auth >> {{token}}
