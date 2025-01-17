.. _detail-files:

Detail Files
============

The data written to a detail file are controlled by the
:nml_n:`detail_item_list` parameter of the :nml_g:`ad_output` namelist
group (for adiabatic calculations) and the :nml_g:`nad_output`
namelist group (for nonadiabatic calculations). This parameter is a
comma-separated list of items to appear in the summary file; the
following subsections describe the items that may appear, grouped
together by functional area. For each item, the corresponding math
symbol is given (if there is one), together with the datatype, and a
brief description. Units (where applicable) are indicated in brackets
[].

Solution Data
-------------

.. list-table::
   :header-rows: 1
   :widths: 15 10 10 65

   * - Item
     - Symbol
     - Datatype
     - Description
   * - :nml_v:`n`
     - :math:`N`
     - integer
     - number of spatial grid points
   * - :nml_v:`omega`
     - :math:`\omega`
     - complex
     - dimensionless eigenfrequency
   * - :nml_v:`x`
     - :math:`x`
     - real(:nml_n:`n`)
     - independent variable; defined in :ref:`dimless-vars` section 
   * - :nml_v:`y_1`
     - :math:`y_{1}`
     - complex(:nml_n:`n`)
     - dependent variable; defined in :ref:`dimless-vars` section
   * - :nml_v:`y_2`
     - :math:`y_{2}`
     - complex(:nml_n:`n`)
     - dependent variable; defined in :ref:`dimless-vars` section
   * - :nml_v:`y_3`
     - :math:`y_{3}`
     - complex(:nml_n:`n`)
     - dependent variable; defined in :ref:`dimless-vars` section
   * - :nml_v:`y_4`
     - :math:`y_{4}`
     - complex(:nml_n:`n`)
     - dependent variable; defined in :ref:`dimless-vars` section
   * - :nml_v:`y_5`
     - :math:`y_{5}`
     - complex(:nml_n:`n`)
     - dependent variable; defined in :ref:`dimless-vars` section
   * - :nml_v:`y_6`
     - :math:`y_{6}`
     - complex(:nml_n:`n`)
     - dependent variable; defined in :ref:`dimless-vars` section

Observables
-----------

.. list-table::
   :header-rows: 1
   :widths: 15 10 10 65

   * - Item
     - Symbol
     - Datatype
     - Description
   * - :nml_v:`freq`
     - ---
     - complex
     - dimensioned frequency; units and reference frame controlled by
       :nml_n:`freq_units` and :nml_n:`freq_frame` parameters
   * - :nml_v:`freq_units`
     - ---
     - string
     - :nml_n:`freq_units` parameter
   * - :nml_v:`freq_frame`
     - ---
     - string
     - :nml_n:`freq_frame` parameter
   * - :nml_v:`f_T`
     - :math:`f_{T}`
     - real
     - Effective temperature perturbation amplitude; evaluated using
       eqn. 5 of :ads_citet:`dupret:2003`
   * - :nml_v:`f_g`
     - :math:`f_{\rm g}`
     - real
     - Effective gravity perturbation amplitude; evaluated using
       eqn. 6 of :ads_citet:`dupret:2003`
   * - :nml_v:`\psi_T`
     - :math:`\psi_{T}`
     - real
     - Effective temperature perturbation phase; evaluated using
       eqn. 5 of :ads_citet:`dupret:2003`
   * - :nml_v:`f_g`
     - :math:`\psi_{\rm g}`
     - real
     - Effective gravity perturbation phase; evaluated using
       eqn. 6 of :ads_citet:`dupret:2003`

Classification & Validation
---------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 10 10 65

   * - Item
     - Symbol
     - Datatype
     - Description
   * - :nml_v:`j`
     - :math:`j`
     - integer
     - unique mode index
   * - :nml_v:`l`
     - :math:`\ell`
     - integer
     - harmonic degree
   * - :nml_v:`l_i`
     - :math:`\ell_{\rm i}`
     - complex
     - effective harmonic degree at inner boundary
   * - :nml_v:`m`
     - :math:`m`
     - integer
     - azimuthal order
   * - :nml_v:`n_p`
     - :math:`\np`
     - integer
     - acoustic-wave winding number
   * - :nml_v:`n_g`
     - :math:`\ng`
     - integer
     - gravity-wave winding number
   * - :nml_v:`n_pg`
     - :math:`\npg`
     - integer
     - radial order within the Eckart-Scuflaire-Osaki-Takata
       scheme (see :ads_citealp:`takata:2006b`)
   * - :nml_v:`omega_int`
     - :math:`\omega_{\rm int}`
     - complex
     - dimensionless eigenfrequency; evaluated by
       integrating :math:`\sderiv{\zeta}{x}`
   * - :nml_v:`dzeta_dx`
     - :math:`\sderiv{\zeta}{x}`
     - complex(:nml_v:`n`)
     - dimensionless frequency weight function; controlled by :nml_n:`zeta_scheme` parameter
   * - :nml_v:`Yt_1`
     - :math:`\mathcal{Y}_{1}`
     - complex(:nml_v:`n`)
     - primary eigenfunction for Takata classification; evaluated
       using a rescaled eqn. 69 of :ads_citet:`takata:2006b`
   * - :nml_v:`Yt_2`
     - :math:`\mathcal{Y}_{2}`
     - complex(:nml_v:`n`)
     - secondary eigenfunction for Takata classification; evaluated
       using a rescaled eqn. 70 of :ads_citet:`takata:2006b`
   * - :nml_v:`I_0`
     - :math:`I_{0}`
     - complex(:nml_v:`n`)
     - first integral for radial modes; evaluated using
       eqn. 42 of :ads_citet:`takata:2006a`
   * - :nml_v:`I_1`
     - :math:`I_{1}`
     - complex(:nml_v:`n`)
     - first integral for dipole modes; evaluated using
       eqn. 43 of :ads_citet:`takata:2006a`
   * - :nml_v:`prop_type`
     - :math:`\varpi`
     - integer(:nml_v:`n`)
     - propagation type; :math:`\varpi = 1` in acoustic-wave regions,
       :math:`\varpi=-1` in gravity-wave regions, and :math:`\varpi=0` in
       evanescent regions

Perturbations
-------------

.. list-table::
   :header-rows: 1
   :widths: 15 10 10 65

   * - Item
     - Symbol
     - Datatype
     - Description
   * - :nml_v:`x_ref`
     - :math:`x_{\rm ref}`
     - real
     - fractional radius of reference location
   * - :nml_v:`xi_r_ref`
     - :math:`\txi_{r,{\rm ref}}`
     - complex
     - radial displacement perturbation at reference location [:math:`R`]
   * - :nml_v:`xi_h_ref`
     - :math:`\txi_{\rm h,ref}`
     - complex
     - radial displacement perturbation at reference location [:math:`R`]
   * - :nml_v:`eul_Phi_ref`
     - :math:`\tPhi'_{\rm ref}`
     - complex
     - Eulerian potential perturbation at reference location [:math:`GM/R`]
   * - :nml_v:`deul_Phi_ref`
     - :math:`(\sderiv{\tPhi'}{x})_{\rm ref}`
     - complex
     - Eulerian potential gradient perturbation at reference location [:math:`GM/R^{2}`]
   * - :nml_v:`lag_S_ref`
     - :math:`\delta\tS_{\rm ref}`
     - complex
     - Lagrangian specific entropy perturbation at reference location [:math:`R`]
   * - :nml_v:`lag_L_ref`
     - :math:`\delta\tL_{\rm R,ref}`
     - complex
     - Lagrangian radiative luminosity perturbation at reference location [:math:`L`]
   * - :nml_v:`xi_r`
     - :math:`\txir`
     - complex(:nml_v:`n`)
     - radial displacement perturbation [:math:`R`]
   * - :nml_v:`xi_h`
     - :math:`\txih`
     - complex(:nml_v:`n`)
     - radial displacement perturbation [:math:`R`]
   * - :nml_v:`eul_Phi`
     - :math:`\tPhi'`
     - complex(:nml_v:`n`)
     - Eulerian potential perturbation [:math:`GM/R`]
   * - :nml_v:`deul_Phi`
     - :math:`\sderiv{\tPhi'}{x}`
     - complex(:nml_v:`n`)
     - Eulerian potential gradient perturbation [:math:`GM/R^{2}`]
   * - :nml_v:`lag_S`
     - :math:`\delta\tS`
     - complex(:nml_v:`n`)
     - Lagrangian specific entropy perturbation [:math:`\cP`]
   * - :nml_v:`lag_L`
     - :math:`\delta\tLrad`
     - complex(:nml_v:`n`)
     - Lagrangian radiative luminosity perturbation [:math:`L`]
   * - :nml_v:`eul_P`
     - :math:`\tP'`
     - complex(:nml_v:`n`)
     - Eulerian total pressure perturbation [:math:`P`]
   * - :nml_v:`eul_rho`
     - :math:`\trho'`
     - complex(:nml_v:`n`)
     - Eulerian density perturbation [:math:`\rho`]
   * - :nml_v:`eul_T`
     - :math:`\tT'`
     - complex(:nml_v:`n`)
     - Eulerian temperature perturbation [:math:`T`]
   * - :nml_v:`lag_P`
     - :math:`\delta\tP`
     - complex(:nml_v:`n`)
     - Lagrangian total pressure perturbation [:math:`P`]
   * - :nml_v:`lag_rho`
     - :math:`\delta\trho`
     - complex(:nml_v:`n`)
     - Lagrangian density perturbation [:math:`\rho`]
   * - :nml_v:`lag_T`
     - :math:`\delta\tT`
     - complex(:nml_v:`n`)
     - Lagrangian temperature perturbation [:math:`T`]

Energetics & Transport
----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 10 10 65

   * - Item
     - Symbol
     - Datatype
     - Description
   * - :nml_v:`eta`
     - :math:`\eta`
     - real
     - normalized growth rate :math:`\eta`; evaluated using expression
       in text of page 1186 of :ads_citet:`stellingwerf:1978`
   * - :nml_v:`E`
     - :math:`E`
     - real
     - mode inertia [:math:`M R^{2}`]; evaluated by integrating
       :math:`\sderiv{E}{x}`
   * - :nml_v:`E_p`
     - :math:`E_{\rm p}`
     - real
     - acoustic mode inertia [:math:`M R^{2}`]; evaluated by
       integrating :math:`\sderiv{E}{x}` where
       :math:`\varpi=1`
   * - :nml_v:`E_g`
     - :math:`E_{\rm g}`
     - real
     - gravity mode inertia [:math:`M R^{2}`]; evaluated by
       integrating :math:`\sderiv{E}{x}` in regions where
       :math:`\varpi=-1`
   * - :nml_v:`E_norm`
     - :math:`E_{\rm norm}`
     - real
     - normalized inertia; evaluation controlled by :nml_n:`inertia_norm`
       parameter
   * - :nml_v:`E_ratio`
     -
     - real
     - ratio of mode inertias inertia inside/outside reference
       location
   * - :nml_v:`H`
     - :math:`H`
     - real
     - mode energy [:math:`G M^{2}/R`]; evaluated as
       :math:`\frac{1}{2} \omega^{2} E`
   * - :nml_v:`W`
     - :math:`W`
     - real
     - mode work [:math:`G M^{2}/R`]; evaluated by
       integrating :math:`\sderiv{W}{x}`
   * - :nml_v:`W_eps`
     - :math:`W_{\epsilon}`
     - real
     - mode work [:math:`G M^{2}/R`]; evaluated by
       integrating :math:`\sderiv{W_{\epsilon}}{x}`
   * - :nml_v:`tau_ss`
     - :math:`\tau_{\rm ss}`
     - real
     - steady-state torque [:math:`G M^{2}/R`]; evaluated by
       integrating :math:`\sderiv{\tau_{\rm ss}}{x}`
   * - :nml_v:`tau_tr`
     - :math:`\tau_{\rm tr}`
     - real
     - steady-state torque [:math:`G M^{2}/R`]; evaluated by
       integrating :math:`\sderiv{\tau_{\rm tr}}{x}`
   * - :nml_v:`dE_dx`
     - :math:`\sderiv{E}{x}`
     - real(:nml_v:`n`)
     - differential inertia [:math:`M R^{2}`]; evaluated using eqn. 3.139 of
       :ads_citet:`aerts:2010`
   * - :nml_v:`dW_dx`\ [#only-N]_
     - :math:`\sderiv{W}{x}`
     - real(:nml_v:`n`)
     - differential work [:math:`GM^{2}/R`]; evaluated using eqn. 25.9
       of :ads_citet:`unno:1989`
   * - :nml_v:`dW_eps_dx`\ [#only-N]_
     - :math:`\sderiv{W_{\epsilon}}{x}`
     - real(:nml_v:`n`)
     - differential nuclear work [:math:`GM^{2}/R`]; evaluated using
       eqn. 25.9 of :ads_citet:`unno:1989`
   * - :nml_v:`dtau_ss_dx`
     - :math:`\sderiv{\tau_{\rm ss}}{x}`
     - real(:nml_v:`n`)
     - steady-state differential torque [`G M^{2}/R`]
   * - :nml_v:`dtau_tr_dx`
     - :math:`\sderiv{\tau_{\rm tr}}{x}`
     - real(:nml_v:`n`)
     - transient differential torque [`G M^{2}/R`]
   * - :nml_v:`alpha_0`
     - :math:`\alpha_{0}`
     - real(:nml_v:`n`)
     - excitation coefficient; evaluated using eqn. 26.10 of
       :ads_citet:`unno:1989`
   * - :nml_v:`alpha_1`
     - :math:`\alpha_{1}`
     - real(:nml_v:`n`)
     - excitation coefficient; evaluated using eqn. 26.12 of
       :ads_citet:`unno:1989`

Rotation
--------

.. list-table::
   :header-rows: 1
   :widths: 15 10 10 65

   * - Item
     - Symbol
     - Datatype
     - Description
   * - :nml_v:`domega_rot`
     - :math:`\delta \omega`
     - real
     - dimensionless first-order rotational splitting; evaluated using eqn. 3.355 of :ads_citet:`aerts:2010`
   * - :nml_v:`dfreq_rot`
     - ---
     - real
     - dimensioned first-order rotational splitting; units and reference frame controlled by
       :nml_n:`freq_units` and :nml_n:`freq_frame` parameters
   * - :nml_v:`beta`
     - :math:`\beta`
     - real
     - rotation splitting coefficient; evaluated by
       integrating :math:`\sderiv{\beta}{x}`
   * - :nml_v:`dbeta_dx`
     - :math:`\sderiv{\beta}{x}`
     - complex(:nml_v:`n`)
     - unnormalized rotation splitting kernel; evaluated using
       eqn. 3.357 of :ads_citet:`aerts:2010`
   * - :nml_v:`lambda`
     - :math:`\lambda`
     - complex(:nml_v:`n`)
     - tidal equation eigenvalue

Stellar Structure
-----------------

.. list-table::
   :header-rows: 1
   :widths: 15 10 10 65

   * - Item
     - Symbol
     - Datatype
     - Description
   * - :nml_v:`M_star`\ [#only-D]_
     - :math:`M`
     - real
     - stellar mass [:math:`\gram`]
   * - :nml_v:`R_star`\ [#only-D]_
     - :math:`R`
     - real
     - stellar radius [:math:`\cm`]
   * - :nml_v:`L_star`\ [#only-D]_
     - :math:`L`
     - real
     - stellar luminosity [:math:`\erg\,\second^{-1}`]
   * - :nml_v:`Delta_p`
     - :math:`\Delta \nu`
     - real
     - asymptotic p-mode large frequency separation [:math:`\sqrt{GM/R^{3}}`]
   * - :nml_v:`Delta_g`
     - :math:`(\Delta P)^{-1}`
     - real
     - asymptotic g-mode inverse period separation [:math:`\sqrt{GM/R^{3}}`]
   * - :nml_v:`V_2`
     - :math:`V_2`
     - real(:nml_v:`n`)
     - structure coefficient; defined in :ref:`struct-coeffs` section
   * - :nml_v:`As`
     - :math:`A^{*}`
     - real(:nml_v:`n`)
     - structure coefficient; defined in :ref:`struct-coeffs` section
   * - :nml_v:`U`
     - :math:`U`
     - real(:nml_v:`n`)
     - structure coefficient; defined in :ref:`struct-coeffs` section
   * - :nml_v:`c_1`
     - :math:`c_{1}`
     - real(:nml_v:`n`)
     - structure coefficient; defined in :ref:`struct-coeffs` section
   * - :nml_v:`Gamma_1`
     - :math:`\Gammi`
     - real(:nml_v:`n`)
     - adiabatic exponent; defined in :ref:`linear-equations` section
   * - :nml_v:`nabla`\ [#only-N]_
     - :math:`\nabla`
     - real(:nml_v:`n`)
     - temperature gradient; defined in :ref:`struct-coeffs` section
       :ref:`dimless-form` section
   * - :nml_v:`nabla_ad`\ [#only-N]_
     - :math:`\nabad`
     - real(:nml_v:`n`)
     - adiabatic temperature gradient; defined in
       :ref:`linear-equations` section
   * - :nml_v:`dnabla_ad`\ [#only-N]_
     - :math:`\dnabad`
     - real(:nml_v:`n`)
     - derivative of adiabatic temperature gradient
   * - :nml_v:`upsilon_T`\ [#only-N]_
     - :math:`\upsT`
     - real(:nml_v:`n`)
     - thermodynamic coefficient; defined in :ref:`linear-equations`
       section
   * - :nml_v:`c_lum`\ [#only-N]_
     - :math:`\clum`
     - real(:nml_v:`n`)
     - structure coefficient; defined in :ref:`struct-coeffs`
       section
   * - :nml_v:`c_rad`\ [#only-N]_
     - :math:`\crad`
     - real(:nml_v:`n`)
     - structure coefficient; defined in :ref:`struct-coeffs`
       section
   * - :nml_v:`c_thn`\ [#only-N]_
     - :math:`\cthn`
     - real(:nml_v:`n`)
     - structure coefficient; defined in :ref:`struct-coeffs`
       section
   * - :nml_v:`c_thk`\ [#only-N]_
     - :math:`\cthk`
     - real(:nml_v:`n`)
     - structure coefficient; defined in :ref:`struct-coeffs`
       section
   * - :nml_v:`c_eps`\ [#only-N]_
     - :math:`\ceps`
     - real(:nml_v:`n`)
     - structure coefficient; defined in :ref:`struct-coeffs`
       section
   * - :nml_v:`kap_rho`\ [#only-N]_
     - :math:`\kaprho`
     - real(:nml_v:`n`)
     - opacity partial; defined in :ref:`linear-equations`
       section
   * - :nml_v:`kap_T`\ [#only-N]_
     - :math:`\kapT`
     - real(:nml_v:`n`)
     - opacity partial; defined in :ref:`linear-equations`
       section
   * - :nml_v:`eps_rho`\ [#only-N]_
     - :math:`\epsrho`
     - real(:nml_v:`n`)
     - nuclear energy generation partial; defined in :ref:`linear-equations`
       section
   * - :nml_v:`eps_T`\ [#only-N]_
     - :math:`\epsT`
     - real(:nml_v:`n`)
     - nuclear energy generation partial; defined in :ref:`linear-equations`
       section
   * - :nml_v:`Omega_rot`
     - :math:`\Omega`
     - real(:nml_v:`n`)
     - rotation angular frequency [:math:`\sqrt{GM/R^{3}}`]
   * - :nml_v:`M_r`\ [#only-D]_
     - :math:`M_r`
     - real(:nml_v:`n`)
     - interior mass [:math:`\gram`]
   * - :nml_v:`P`\ [#only-D]_
     - :math:`P`
     - real(:nml_v:`n`)
     - total pressure [:math:`\barye`]
   * - :nml_v:`rho`\ [#only-D]_
     - :math:`\rho`
     - real(:nml_v:`n`)
     - density [:math:`\gram\,\cm^{-3}`]
   * - :nml_v:`T`\ [#only-D]_
     - :math:`T`
     - real(:nml_v:`n`)
     - temperature [:math:`\kelvin`]
       
Tidal Response
--------------

Note that these items are available only when using :program:`gyre_tides`.

.. list-table::
   :header-rows: 1
   :widths: 15 10 10 65

   * - Item
     - Symbol
     - Datatype
     - Description
   * - :nml_v:`k`
     - :math:`k`
     - integer
     - Fourier harmonic
   * - :nml_v:`eul_Psi_ref`
     - :math:`\tPsi'_{\rm ref}`
     - complex
     - Eulerian total potential perturbation at reference location [:math:`GM/R`]
   * - :nml_v:`Phi_T_ref`
     - :math:`\tPhi_{\rm T, ref}`
     - real
     - tidal potential at reference location [:math:`GM/R`]
   * - :nml_v:`Omega_orb`
     - :math:`\Omega_{\rm orb}`
     - real
     - orbital angular frequency; units and reference frame controlled by
       :nml_n:`freq_units` and :nml_n:`freq_frame` parameters
   * - :nml_v:`q`
     - :math:`q`
     - real
     - ratio of secondary mass to primary mass
   * - :nml_v:`e`
     - :math:`e`
     - real
     - orbital eccentricity
   * - :nml_v:`R_a`
     - :math:`R/a`
     - real
     - ratio of primary radius to orbital semi-major axis
   * - :nml_v:`c`
     - :math:`c_{\ell,m,k}`
     - real
     - tidal expansion coefficient
   * - :nml_v:`G_1`
     - :math:`G_{1;\ell,m,k}`
     - real
     - secular orbital evolution coefficient
   * - :nml_v:`G_2`
     - :math:`G_{2;\ell,m,k}`
     - real
     - secular orbital evolution coefficient
   * - :nml_v:`G_3`
     - :math:`G_{3;\ell,m,k}`
     - real
     - secular orbital evolution coefficient
   * - :nml_v:`G_4`
     - :math:`G_{4;\ell,m,k}`
     - real
     - secular orbital evolution coefficient
   * - :nml_v:`eul_Psi`
     - :math:`\tPsi'`
     - complex(:nml_v:`n`)
     - Eulerian total potential perturbation [:math:`GM/R`]
   * - :nml_v:`Phi_T`
     - :math:`\tPhi_{{\rm T}}`
     - real(:nml_v:`n`)
     - tidal potential [:math:`GM/R`]

.. rubric:: Footnotes

.. [#only-N] This option is available only for stellar models with :ref:`N capability <model-caps>`

.. [#only-D] This option is available only for stellar models with :ref:`D capability <model-caps>`

		
