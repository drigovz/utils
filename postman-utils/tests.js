// tests das requests:

pm.test("result is correct", () => {
    result = false;

    if (pm.response.json().item.Id &&
        pm.response.json().item.Name) {
        result = true;
    }

    pm.expect(result).to.be.true;
});