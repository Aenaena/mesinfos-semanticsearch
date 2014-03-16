store = {}

module.exports = {

    getItem: function(key){ store[key]; },
    setItem: function(key, value){ store[key] = value; }

}