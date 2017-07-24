import React, {Component} from 'react'
import array_ensure from '../helpers/array_ensure'
import isPlainObject from 'lodash/isPlainObject'

export default class BaseComponent extends Component
  constructor: (props) ->
    super props

    if @sync_state_to_props
      @state ?= {}
      @sync_state_to_props = array_ensure @sync_state_to_props
      for prop in @sync_state_to_props
        if isPlainObject prop
          for state_field, clb of prop
            @state[state_field] = clb @props
        else
          @state[prop] = @props[prop]

      instanceComponentWillReceiveProps = @componentWillReceiveProps
      @componentWillReceiveProps = (new_props) =>
        instanceComponentWillReceiveProps?.call @, new_props

        for prop in @sync_state_to_props
          if isPlainObject prop
            for state_field, clb of prop
              @setState "#{state_field}": clb new_props
          else
            new_prop_val = new_props[prop]
            @setState "#{prop}": new_prop_val unless @state[prop] is new_prop_val
