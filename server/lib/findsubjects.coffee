module.exports = (triples) ->

    subjects = []
    for t in triples when t.s[0] is '?' 
        subjects.push t.s unless t.s in subjects

    return subjects