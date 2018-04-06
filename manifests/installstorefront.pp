#Class installing Citrix Storefront feature
class xd7storefront::installstorefront inherits xd7storefront {
  dsc_xd7feature { 'XD7Storefront':
    dsc_role       => 'Storefront',
    dsc_sourcepath => $xd7storefront::sourcepath,
    dsc_ensure     => 'present',
    notify         => Reboot['after_run']
  }

  reboot { 'after_run':
    apply => finished,
  }
}
