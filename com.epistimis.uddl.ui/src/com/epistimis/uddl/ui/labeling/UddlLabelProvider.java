/*
 * generated by Xtext 2.33.0
 */
/*
 * Copyright (c) 2022 - 2024 Epistimis LLC (http://www.epistimis.com).
 */
package com.epistimis.uddl.ui.labeling;

import com.epistimis.uddl.uddl.LogicalEnumeratedBase;
import com.google.inject.Inject;
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider;
import org.eclipse.jface.viewers.StyledString;
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider;

/**
 * Provides labels for EObjects.
 * 
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#label-provider
 */
public class UddlLabelProvider extends DefaultEObjectLabelProvider {

	@Inject
	public UddlLabelProvider(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}

	
	StyledString text(LogicalEnumeratedBase obj) {
		return new StyledString(obj.getName()).append(new StyledString(" : " + obj.getDescription(),StyledString.QUALIFIER_STYLER));
	}

	// Labels and icons can be computed like this:
	
//	String text(Greeting ele) {
//		return "A greeting to " + ele.getName();
//	}
//
//	String image(Greeting ele) {
//		return "Greeting.gif";
//	}
}