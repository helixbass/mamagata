import get_saved, {clear_cache} from './get_saved'
import find from 'lodash/find'

export default (data) ->
  saved = do get_saved

  {localStorage} = window
  return unless localStorage

  updated =
    if find saved, name: data.name
      for _saved in saved
        if _saved.name is data.name
          data
        else
          _saved
    else
      saved.concat data

  localStorage.setItem 'saved',
    JSON.stringify updated

  do clear_cache
