//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "monkeyTestApp.h"
#include "monkeyApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

InputParameters
monkeyTestApp::validParams()
{
  InputParameters params = monkeyApp::validParams();
  return params;
}

monkeyTestApp::monkeyTestApp(InputParameters parameters) : MooseApp(parameters)
{
  monkeyTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

monkeyTestApp::~monkeyTestApp() {}

void
monkeyTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  monkeyApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"monkeyTestApp"});
    Registry::registerActionsTo(af, {"monkeyTestApp"});
  }
}

void
monkeyTestApp::registerApps()
{
  registerApp(monkeyApp);
  registerApp(monkeyTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
monkeyTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  monkeyTestApp::registerAll(f, af, s);
}
extern "C" void
monkeyTestApp__registerApps()
{
  monkeyTestApp::registerApps();
}
