API Reference
=============

.. toctree::
   :titlesonly:
   :maxdepth: 3

{% for page in pages %}
{% if page.type == "module" %}
   {{ page.name }}/index
{% endif %}
{% endfor %}

This is the complete API reference for all modules and packages.

Package Overview
----------------

{% for page in pages %}
{% if page.type == "module" and "." not in page.name %}
.. card:: {{ page.name }}
   :class-card: sd-border-1

   {{ page.summary | truncate(200) }}
   
   .. button-ref:: {{ page.name }}/index
      :color: primary
      :outline:
      
      View {{ page.name }} API →
{% endif %}
{% endfor %}

Module Structure
----------------

.. code-block:: text

{% for page in pages %}
{% if page.type == "module" %}
   {% set indent = page.name.count('.') * 3 %}
   {{ ' ' * indent }}├── {{ page.name.split('.')[-1] }}
{% endif %}
{% endfor %}