import React, {Component} from 'react'
import array_ensure from '../helpers/array_ensure'
import _int from '../helpers/_int'
import {capitalize} from 'underscore.string'
import isFunction from 'lodash/isFunction'
import isPlainObject from 'lodash/isPlainObject'
import isInteger from 'lodash/isInteger'

export default class BaseComponent extends Component
  constructor: (props) ->
    super props

    if @stateChangeHandlers
      for stateField in array_ensure @stateChangeHandlers
        if isPlainObject stateField
          for _stateField, opts of stateField
            unless isPlainObject opts
              opts = initial: opts
            if opts.syncToProps and isFunction opts.initial
              (@syncStateToProps ?= [])
              .push
                "#{_stateField}": opts.initial
            opts.initial = opts.initial @props if isFunction opts.initial
            @addStateChangeHandler {stateField: _stateField, opts...}
        else
          @addStateChangeHandler {stateField, initial: ''}
        # TODO: keep initial in sync w/ updated props via componentWillReceiveProps?

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

  addStateChangeHandler: ({stateField, initial, type}) ->
    @state ?= {}
    @state[stateField] = initial
    unless type?
      type = 'int' if isInteger initial
    methodName = "handle#{ capitalize stateField }Change"
    @[methodName] = (event) =>
      if event?.target
        {target: {type: _type, value, checked}} = event
      else
        value = event
      val =
        if _type is 'checkbox'
          checked
        else
          value
      val = _int val if type is 'int'
      @setState "#{stateField}": val
