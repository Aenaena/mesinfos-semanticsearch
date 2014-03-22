ContactsService = ($http) ->
    find: (q, cb) ->
        params = doctype: 'contact', q: q
        $http(method: 'GET', url: 'search', params: params).then cb


SearchCtl = ($scope, $contacts) ->
    $scope.query = ''
    $scope.advices = []

    contactAC = (q, cb) ->
        $contacts.find(q, cb)

    findMatches = (q, cb) ->
        q2 = q.toLowerCase().trim()

        if q2 is 'qui'
            cb ['m\'a appelé', 'ai-je appelé', 'm\'a viré de l\'argent'].map (x) -> q2 + x
        else if q2.match /^quand \w/
            contactAC

        else if q2 is ''

        'quand': ['ai-je appelé', 'ai-je acheté',
            concat(contactAC, 'm\'a appelé')
        ]
        'quand ai-je appelé': [contactAC]
        'quand ai-je acheté':
        'qui m\'a appelé': [timeAC]

        matches = []
        substrRegex = new RegExp q, 'i'
        cb matches

    $scope.searchOptions = {
        displayKey: 'num',
        source: findMatches
        templates:
            empty: """<div class="empty-message">Je ne comprend pas.</div>"""
            suggestion: (item) -> """
                <p>#{item.display}</p>
            """

angular.module('semsearch.search-autocomplete')
.controller('SearchCtl', ['$scope', '$contacts', SearchCtl])
.factory('$contacts', ContactsService)

