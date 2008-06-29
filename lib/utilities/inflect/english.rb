module Waves
  module Inflect
    # Extends Waves::Inflect::InflectorMethods
    module English
        
      extend InflectorMethods

      # One argument means singular and plural are the same.
      word 'equipment'
      word 'information'
      word 'money'
      word 'species'
      word 'series'
      word 'fish'
      word 'sheep'
      word 'moose'
      word 'hovercraft'

      # Two arguments defines a singular and plural exception.
      word 'Swiss'     , 'Swiss'
      word 'life'      , 'lives'
      word 'wife'      , 'wives'
      word 'cactus'    , 'cacti'
      word 'goose'     , 'geese'
      word 'criterion' , 'criteria'
      word 'alias'     , 'aliases'
      word 'status'    , 'statuses'
      word 'axis'      , 'axes'
      word 'crisis'    , 'crises'
      word 'testis'    , 'testes'
      word 'child'     , 'children'
      word 'person'    , 'people'
      word 'potato'    , 'potatoes'
      word 'tomato'    , 'tomatoes'
      word 'buffalo'   , 'buffaloes'
      word 'torpedo'   , 'torpedoes'
      word 'quiz'      , 'quizes'
      word 'matrix'    , 'matrices'
      word 'vertex'    , 'vetices'
      word 'index'     , 'indices'
      word 'ox'        , 'oxen'
      word 'mouse'     , 'mice'
      word 'louse'     , 'lice'
      word 'thesis'    , 'theses'
      word 'thief'     , 'thieves'
      word 'analysis'  , 'analyses'

      # One-way singularization exception (convert plural to singular).
      singular_word 'cactus', 'cacti'

      # General rules.
      rule 'hive' , 'hives'
      rule 'rf'   , 'rves'
      rule 'af'   , 'aves'
      rule 'ero'  , 'eroes'
      rule 'man'  , 'men'
      rule 'ch'   , 'ches'
      rule 'sh'   , 'shes'
      rule 'ss'   , 'sses'
      rule 'ta'   , 'tum'
      rule 'ia'   , 'ium'
      rule 'ra'   , 'rum'
      rule 'ay'   , 'ays'
      rule 'ey'   , 'eys'
      rule 'oy'   , 'oys'
      rule 'uy'   , 'uys'
      rule 'y'    , 'ies'
      rule 'x'    , 'xes'
      rule 'lf'   , 'lves'
      rule 'us'   , 'uses'
      rule ''     , 's'

      # One-way singular rules.
      singular_rule 'of' , 'ofs' # proof
      singular_rule 'o'  , 'oes' # hero, heroes
      singular_rule 'f'  , 'ves'

      # One-way plural rules.
      plural_rule 'fe' , 'ves' # safe, wife
      plural_rule 's'  , 'ses'
        
    end
  end
end