# Several form fields under one label

Element's form item holding more than one control, each with a form item
of its own for its value and rules, laid out in columns – a date beside
a time, as Element's own examples write it.

## Usage

``` r
el_form_item(label = NULL, ..., spans = NULL, required = NULL, gutter = NULL)
```

## Arguments

- label:

  Label text.

- ...:

  Fields, from
  [`el_form_field()`](https://kaipingyang.github.io/shiny.element/reference/el_form_field.md)
  (whose `label` is not shown), and strings drawn between them, such as
  `"-"`.

- spans:

  Column spans out of 24, one per entry in `...`. By default a string
  takes 2 and the fields share the rest.

- required:

  Whether to mark the label as required. The fields' own
  [`el_rule()`](https://kaipingyang.github.io/shiny.element/reference/el_rule.md)s
  do the checking.

- gutter:

  Space between the columns, in pixels, as
  [`el_row()`](https://kaipingyang.github.io/shiny.element/reference/el_row.md)'s.

## Value

A field declaration, for
[`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md).

## Examples

``` r
el_form(
  el_form_item(
    "Activity time",
    el_form_field("date1", "date-picker", style = "width: 100%"),
    "-",
    el_form_field("date2", "time-picker", style = "width: 100%")
  )
)
#> <div id="el_form_581ba20f-e070-468b-acf0-eb62b4954f34" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_form_581ba20f-e070-468b-acf0-eb62b4954f34_container" style="display: contents">
#>   <el-form :model="model" :rules="rules" ref="form" :label-width="labelWidth" :label-position="labelPosition" :inline="inline" :size="size === null ? undefined : size" :disabled="disabled === null ? undefined : disabled" :show-message="showMessage === null ? undefined : showMessage" :inline-message="inlineMessage === null ? undefined : inlineMessage" :status-icon="statusIcon === null ? undefined : statusIcon" :hide-required-asterisk="hideRequiredAsterisk === null ? undefined : hideRequiredAsterisk" :label-suffix="labelSuffix === null ? undefined : labelSuffix" :validate-on-rule-change="validateOnRuleChange === null ? undefined : validateOnRuleChange" @validate="elEmitValidate" :require-asterisk-position="requireAsteriskPosition === null ? undefined : requireAsteriskPosition" :scroll-into-view-options="scrollIntoViewOptions === null ? undefined : scrollIntoViewOptions" :scroll-to-error="scrollToError === null ? undefined : scrollToError">
#>     <el-form-item v-for="f in fields" :key="f.key || f.prop" :prop="f.prop" :label="f.label" :required="f.required" :rules="f.rules" :error="f.error" :label-width="f.labelWidth" :size="f.size" :inline-message="f.inlineMessage" :show-message="f.showMessage" :label-position="f.labelPosition" :validate-status="f.validateStatus" :for="f.for"><template v-slot:label><span v-if="f.labelHtml" v-html="f.labelHtml"></span><span v-else>{{f.label}}</span></template><template v-slot:error="scope"><div class="el-form-item__error"><span v-if="f.errorHtml" v-html="f.errorHtml"></span><span v-else>{{scope.error}}</span></div></template><el-row v-if="f.parts" :gutter="f.gutter" style="width: 100%"><el-col v-for="p in f.parts" :key="p.key || p.prop" :span="p.span" :style="p.separator ? 'text-align: center' : undefined"><span v-if="p.separator" style="color: var(--el-text-color-secondary)">{{ p.separator }}</span><el-form-item v-else :prop="p.prop" :required="p.required" :error="p.error" :size="p.size" :show-message="p.showMessage"><component :is="p.tag" v-model="model[p.prop]" v-bind="p.props"><template v-if="p.text">{{ p.text }}</template><component v-for="o in (p.options || [])" :is="p.optionTag" :key="o.value" v-bind="p.optionProps" :label="o.label" :value="o.value"><template v-if="o.text">{{ o.text }}</template></component></component></el-form-item></el-col></el-row><template v-else><component :is="f.tag" v-model="model[f.prop]" v-bind="f.props"><template v-if="f.text">{{ f.text }}</template><component v-for="o in (f.options || [])" :is="f.optionTag" :key="o.value" v-bind="f.optionProps" :label="o.label" :value="o.value"><template v-if="o.text">{{ o.text }}</template></component></component></template></el-form-item>
#>     <el-form-item><el-button type="primary" @click="handleSubmit">{{ submitLabel }}</el-button></el-form-item>
#>   </el-form>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"model":{"date1":"","date2":""},"rules":{},"fields":[{"key":"date1+date2","label":"Activity time","parts":[{"prop":"date1","tag":"el-date-picker","props":{"style":"width: 100%"},"span":11},{"separator":"-","span":2,"key":"sep2"},{"prop":"date2","tag":"el-time-picker","props":{"style":"width: 100%"},"span":11}]}],"labelWidth":"100px","labelPosition":"right","inline":false,"submitLabel":"Submit","resetLabel":"","submitCount":0,"valid":false,"size":null,"disabled":null,"showMessage":null,"inlineMessage":null,"statusIcon":null,"hideRequiredAsterisk":null,"labelSuffix":null,"validateOnRuleChange":null,"requireAsteriskPosition":null,"scrollIntoViewOptions":null,"scrollToError":null},"methods":{"elEmitValidate":"function() { window.shinyVue.emit('el_form_581ba20f-e070-468b-acf0-eb62b4954f34', 'validate', arguments); }","handleSubmit":"function() { var self = this; this.$refs.form.validate(function(ok) { self.submitCount++; self.valid = ok; window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"el_form_581ba20f-e070-468b-acf0-eb62b4954f34\" + '_valid', ok); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"el_form_581ba20f-e070-468b-acf0-eb62b4954f34\" + '_submit', self.submitCount); }); }","shinyVueReceive":"function(d) { var self = this, action = d['.action']; delete d['.action']; if (d.model) { Object.keys(d.model).forEach(function(k) { self.model[k] = d.model[k]; }); delete d.model; } function each(fs, cb) { fs.forEach(function(f) { (f.parts || [f]).forEach(function(p) { if (p.prop) cb(p); }); }); } if (d['.fields']) { var model = {}, rules = {}; each(d['.fields'], function(f) { model[f.prop] = Object.prototype.hasOwnProperty.call(self.model, f.prop) ? self.model[f.prop] : f.value; if (f.rules) rules[f.prop] = f.rules; delete f.value; delete f.rules; }); self.model = model; self.rules = rules; self.fields = d['.fields']; delete d['.fields']; } if (d['.errors']) { Object.keys(d['.errors']).forEach(function(k) { each(self.fields, function(f) { if (f.prop === k) f.error = d['.errors'][k] || ''; }); }); delete d['.errors']; } if (action === 'validate') self.handleSubmit(); else if (action === 'reset') self.handleReset(); else if (action === 'clearValidate') { if (self.$refs.form) self.$refs.form.clearValidate(d.props || undefined); delete d.props; } return d; }","handleReset":"function() { this.$refs.form.resetFields(); }"}},"input":"model","rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":["options.methods.elEmitValidate","options.methods.handleSubmit","options.methods.shinyVueReceive","options.methods.handleReset"]}</script>
#> </div>
```
