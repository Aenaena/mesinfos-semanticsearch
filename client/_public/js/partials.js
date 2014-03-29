angular.module('partials', [])
.run(['$templateCache', function($templateCache) {
  return $templateCache.put('/partials/welcome.html', [
'',
'<div class="page-header">',
'  <h1>SemanticSearch</h1>',
'  <p class="lead">Posez votre question dans la barre de recherche ci-dessus.</p>',
'</div>',''].join("\n"));
}]);