/*
 * generated by Xtext 2.33.0
 */
/*
 * Copyright (c) 2022 - 2024 Epistimis LLC (http://www.epistimis.com).
 */
package com.epistimis.uddl.formatting2

import com.epistimis.uddl.services.UddlGrammarAccess
import com.epistimis.uddl.uddl.ConceptualAssociation
import com.epistimis.uddl.uddl.ConceptualCharacteristic
import com.epistimis.uddl.uddl.ConceptualCompositeQuery
import com.epistimis.uddl.uddl.ConceptualComposition
import com.epistimis.uddl.uddl.ConceptualDataModel
import com.epistimis.uddl.uddl.ConceptualElement
import com.epistimis.uddl.uddl.ConceptualEntity
import com.epistimis.uddl.uddl.ConceptualParticipant
import com.epistimis.uddl.uddl.ConceptualQuery
import com.epistimis.uddl.uddl.ConceptualQueryComposition
import com.epistimis.uddl.uddl.DataModel
import com.epistimis.uddl.uddl.LogicalAssociation
import com.epistimis.uddl.uddl.LogicalCharacteristic
import com.epistimis.uddl.uddl.LogicalCompositeQuery
import com.epistimis.uddl.uddl.LogicalComposition
import com.epistimis.uddl.uddl.LogicalCoordinateSystem
import com.epistimis.uddl.uddl.LogicalDataModel
import com.epistimis.uddl.uddl.LogicalElement
import com.epistimis.uddl.uddl.LogicalEntity
import com.epistimis.uddl.uddl.LogicalEnumerated
import com.epistimis.uddl.uddl.LogicalEnumeratedSet
import com.epistimis.uddl.uddl.LogicalEnumerationLabel
import com.epistimis.uddl.uddl.LogicalMeasurementSystem
import com.epistimis.uddl.uddl.LogicalParticipant
import com.epistimis.uddl.uddl.LogicalQuery
import com.epistimis.uddl.uddl.LogicalQueryComposition
import com.epistimis.uddl.uddl.LogicalReferencePoint
import com.epistimis.uddl.uddl.LogicalReferencePointPart
import com.epistimis.uddl.uddl.LogicalValueTypeUnit
import com.epistimis.uddl.uddl.PlatformAssociation
import com.epistimis.uddl.uddl.PlatformCharacteristic
import com.epistimis.uddl.uddl.PlatformCompositeQuery
import com.epistimis.uddl.uddl.PlatformComposition
import com.epistimis.uddl.uddl.PlatformDataModel
import com.epistimis.uddl.uddl.PlatformDataType
import com.epistimis.uddl.uddl.PlatformElement
import com.epistimis.uddl.uddl.PlatformEntity
import com.epistimis.uddl.uddl.PlatformParticipant
import com.epistimis.uddl.uddl.PlatformQuery
import com.epistimis.uddl.uddl.PlatformQueryComposition
import com.epistimis.uddl.uddl.PlatformStruct
import com.epistimis.uddl.uddl.PlatformStructMember
import com.google.inject.Inject
import java.util.List
import java.util.function.Predicate
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.formatting.impl.FormattingConfig
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.formatting2.regionaccess.ISemanticRegion

import static com.epistimis.uddl.uddl.UddlPackage.Literals.*

class UddlFormatter extends AbstractFormatter2 {

	@Inject extension UddlGrammarAccess

	// This API works with Formatting v1, not v2
	// TODO: What is the V2 equivalent for this?
	// Suggested by https://github.com/cdietrich/xtext-maven-example/blob/master/org.xtext.example.mydsl/src/org/xtext/example/mydsl/formatting/MyDslFormatter.java
	def protected void configureFormatting(FormattingConfig c) {
		// It's usually a good idea to activate the following three statements.
		// They will add and preserve newlines around comments
		c.setLinewrap(0, 1, 2).before(getSL_COMMENTRule());
		c.setLinewrap(0, 1, 2).before(getML_COMMENTRule());
		c.setLinewrap(0, 1, 1).after(getML_COMMENTRule());
		c.autoLinewrap = 120; // Default is 500 if not set. // See https://www.eclipse.org/forums/index.php/t/531139/
	}

// TODO: It looks like this is the method that should be overridden to do configuration - but how to do the configuration?
//	override void initialize(FormatterRequest request) {
//		super.initialize(request);
//		//configureFormatting()
//	}
	
	/**
	 * Several standard methods needed for formatting
	 * 1) All objects will have
	 * 		A) '{' and '};' on a newline.
	 * 		B) All content inside the '{' and '}' will be indented one tab
	 * 
	 * NOTES: Because we don't know the structure of the object, we don't know how to format its
	 * content. So we format the open and close separately
	 * 
	 * 2) '{' and '}' for scoping means
	 * 		A) all content indented one tab further
	 * 		B) '{' on newline after name/description of scope
	 * 
	 * 3) '[' and ']' for lists means
	 * 		A) all list content have 1 space between
	 * 		B) '[', ']' and content all on the same line
	 * 	C) Some lists contain more than a single token per list object. In those cases, the 
	 * 			list object will be bounded by  '(' and ')' - insert a newline after each ')'. 
	 * 			Ideally, any list that contains any list objects should default to all the list items being formatted one per line
	 * 		D) Even simple lists can eventually get too long - we should have a configurable line break (default 80 chars) so that 
	 * 			all lines of list tokens break before going over the line length limit.
	 * 
	 */
	/** General functions */
	def void objOpen(EObject obj, extension IFormattableDocument document) {
		obj.regionFor.keyword('{').prepend[setNewLines(1, 1, 2)];
	}

	def void objClose(EObject obj, extension IFormattableDocument document) {
		obj.regionFor.keyword('};').surround[noSpace].append[setNewLines(1, 1, 2)];
	}

	def void formatContainerContents(EList<? extends EObject> objs, extension IFormattableDocument document) {
		for (obj : objs) {
			obj.prepend[setNewLines(1, 1, 2)].append[setNewLines(1, 1, 2)]
		}
	}

	def void formatContainer(EObject obj, extension IFormattableDocument document) {
		val open = obj.regionFor.keyword("{")
		val close = obj.regionFor.keyword("}")
		open.prepend[setNewLines(1, 1, 2)].append[setNewLines(1, 1, 2)]
		close.prepend[setNewLines(1, 1, 2)].append[setNewLines(1, 1, 2)]
		interior(open, close)[indent]
	}

	def void formatObj(EObject obj, extension IFormattableDocument document) {
		val open = obj.regionFor.keyword("{")
		val close = obj.regionFor.keyword("};")
		open.prepend[setNewLines(1, 1, 2)].append[setNewLines(1, 1, 2)]
		close.prepend[setNewLines(1, 1, 2)].append[setNewLines(1, 1, 2)];
		interior(open, close)[indent]

	}

	def void formatSubobj(EObject obj, extension IFormattableDocument document) {
		val open = obj.regionFor.keyword("(")
		val close = obj.regionFor.keyword(")")
		open.prepend[newLine]
		interior(open, close)[indent]
	}

	val Predicate<EObject> enumContentCheck =  [obj | 
		{
			// Containers always get full line treatment
			if (obj instanceof LogicalEnumeratedSet) { return true; } 
			if (obj instanceof LogicalEnumerated) { return true; } 
			// labels only get full line treatment if they have a description
			if (obj instanceof LogicalEnumerationLabel) {
				val desc = (obj as LogicalEnumerationLabel).description;
				if (desc?.length > 0) { return true; }
			}
			// All others return false
			return false;
		}
	];
	val Predicate<EObject> alwaysTrue =  [true];

	/**
	 * TODO: asLine should be a predicate
	 * TODO: list bounds themselves are not indented, just the contents. To indent the list bounds, must identify the semantic regions that 
	 * are on the outside of them (so the bounds become part of the 'interior' region. Alternatively,indent them individually - though that doesn't
	 * seem to have the desired effect
	 */
	def void formatListContainer(EObject obj, List<EObject> contents, extension IFormattableDocument document,Predicate<EObject> asLine) {
		val open = obj.regionFor.keyword("[")
		val close = obj.regionFor.keyword("]")
		// Always start the list on a new line
		open.prepend[setNewLines(1, 1, 2)].append[oneSpace];
		close.surround[oneSpace];
		contents.formatList(document,asLine);
		interior(open, close)[indent]
//		open.prepend[indent]
//		close.prepend[indent]		
	}

	def void formatList(List<EObject> objs, extension IFormattableDocument document,Predicate<EObject> asLine) {
		for (EObject obj : objs) {
			if (asLine.test(obj)) {
				obj.prepend[setNewLines(1, 1, 2)]
				obj.append[setNewLines(1, 1, 2)]
			} else {
				obj.surround[oneSpace]				
			}
			// Format the object itself (which may be also be a list)
			obj.format
		}
	}

	def void formatAttribute(ISemanticRegion attrStart, ISemanticRegion attrEnd,
		extension IFormattableDocument document) {
		attrStart.prepend[setNewLines(1, 1, 2)]
		attrEnd.append[setNewLines(1, 1, 2)]
	}

	def void formatAttributeElement(ISemanticRegion elem, extension IFormattableDocument document) {
		elem.surround[oneSpace]
	}

	def void formatAttributeElement(EObject obj, extension IFormattableDocument document) {
		obj.surround[oneSpace];
	}

	/** Model specific functions */
	def dispatch void format(DataModel dataModel, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc.
		dataModel.formatContainer(document)
		for (conceptualDataModel : dataModel.cdm) {
			conceptualDataModel.format
		}
		for (logicalDataModel : dataModel.ldm) {
			logicalDataModel.format
		}
		for (platformDataModel : dataModel.pdm) {
			platformDataModel.format
		}
	}

	def dispatch void format(ConceptualDataModel conceptualDataModel, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc.
		conceptualDataModel.formatContainer(document);

		for (conceptualElement : conceptualDataModel.element) {
			conceptualElement.append[setNewLines(1, 1, 2)]
			conceptualElement.format
		}
		for (_conceptualDataModel : conceptualDataModel.cdm) {
			_conceptualDataModel.append[setNewLines(1, 1, 2)]
			_conceptualDataModel.format
		}
	}

	def dispatch void format(LogicalDataModel logicalDataModel, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc.
		logicalDataModel.formatContainer(document);

		for (logicalElement : logicalDataModel.element) {
			logicalElement.append[setNewLines(1, 1, 2)]
			logicalElement.format
		}
		for (_logicalDataModel : logicalDataModel.ldm) {
			_logicalDataModel.append[setNewLines(1, 1, 2)]
			_logicalDataModel.format
		}
	}

	def dispatch void format(PlatformDataModel platformDataModel, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc.
		platformDataModel.formatContainer(document);

		for (platformElement : platformDataModel.element) {
			platformElement.append[setNewLines(1, 1, 2)]
			platformElement.format
		}
		for (_platformDataModel : platformDataModel.pdm) {
			_platformDataModel.append[setNewLines(1, 1, 2)]
			_platformDataModel.format
		}
	}

	/** Conceptual */
	def dispatch void format(ConceptualElement obj, extension IFormattableDocument document) {
		obj.prepend[setNewLines(1, 1, 2)]
		// obj.regionFor.feature(UDDL_ELEMENT__DESCRIPTION).append[newLine]
		formatObj(obj, document);
		for (EObject contained : obj.eContents) {
			contained.format
		}
	}

	def dispatch void formatEntity(ConceptualEntity obj, extension IFormattableDocument document) {
		obj.formatObj(document);
		for (c : obj.composition) {
			c.format
			c.append[setNewLines(1, 1, 2)]
		}
	}

	def dispatch void format(ConceptualEntity obj, extension IFormattableDocument document) {
		obj.formatEntity(document)
	}

	def dispatch void format(ConceptualAssociation obj, extension IFormattableDocument document) {
		obj.formatEntity(document)

		obj.formatListContainer( List.copyOf(obj.participant.toList), document, alwaysTrue);

//		for (c : obj.participant) {
//			c.format
//			c.append[setNewLines(1, 1, 2)]
//		}
	}

	def dispatch void formatCharacteristic(ConceptualCharacteristic obj, extension IFormattableDocument document) {
		formatAttributeElement(obj.regionFor.feature(CONCEPTUAL_CHARACTERISTIC__ROLENAME), document);
		formatAttributeElement(obj.regionFor.feature(CONCEPTUAL_CHARACTERISTIC__DESCRIPTION), document);
		formatAttributeElement(obj.regionFor.feature(CONCEPTUAL_CHARACTERISTIC__SPECIALIZES), document);
	}

	def dispatch void format(ConceptualComposition obj, extension IFormattableDocument document) {
		obj.formatCharacteristic(document);
	}

	def dispatch void format(ConceptualParticipant obj, extension IFormattableDocument document) {
		obj.formatCharacteristic(document);
		formatAttributeElement(obj.regionFor.feature(CONCEPTUAL_PARTICIPANT__SOURCE_LOWER_BOUND), document);
		formatAttributeElement(obj.regionFor.feature(CONCEPTUAL_PARTICIPANT__SOURCE_UPPER_BOUND), document);
	}

	def dispatch void format(ConceptualQuery obj, extension IFormattableDocument document) {
		obj.formatObj(document);
		formatAttributeElement(obj.regionFor.feature(CONCEPTUAL_QUERY__SPECIFICATION), document);
	}

	def dispatch void format(ConceptualCompositeQuery obj, extension IFormattableDocument document) {
		obj.formatObj(document);
		formatAttributeElement(obj.regionFor.feature(CONCEPTUAL_COMPOSITE_QUERY__IS_UNION), document);
		for (c : obj.composition) {
			c.format
			c.append[setNewLines(1, 1, 2)]
		}
	}
	def dispatch void format(ConceptualQueryComposition obj, extension IFormattableDocument document) {
		formatAttributeElement(obj.regionFor.feature(CONCEPTUAL_QUERY_COMPOSITION__TYPE), document);
		formatAttributeElement(obj.regionFor.feature(CONCEPTUAL_QUERY_COMPOSITION__ROLENAME), document);
	}

	/** Logical  */
	/**
	 * By default, any Logical that doesn't have its own formtter will call this method
	 */
	def dispatch void format(LogicalElement obj, extension IFormattableDocument document) {
		obj.prepend[setNewLines(1, 1, 2)]
		formatObj(obj, document);
		for (EObject contained : obj.eContents) {
			contained.format
		}
	}

	def dispatch void formatEntity(LogicalEntity obj, extension IFormattableDocument document) {
		obj.formatObj(document);
		for (c : obj.composition) {
			c.format
			c.append[setNewLines(1, 1, 2)]
		}
	}

	def dispatch void format(LogicalEntity obj, extension IFormattableDocument document) {
		obj.formatEntity(document);
	}

	def dispatch void formatCharacteristic(LogicalCharacteristic obj, extension IFormattableDocument document) {
		formatAttributeElement(obj.regionFor.feature(LOGICAL_CHARACTERISTIC__ROLENAME), document);
		formatAttributeElement(obj.regionFor.feature(LOGICAL_CHARACTERISTIC__DESCRIPTION), document);
		formatAttributeElement(obj.regionFor.feature(LOGICAL_CHARACTERISTIC__SPECIALIZES), document);
	}

	def dispatch void format(LogicalComposition obj, extension IFormattableDocument document) {
		obj.formatCharacteristic(document);
	}

	def dispatch void format(LogicalParticipant obj, extension IFormattableDocument document) {
		obj.formatCharacteristic(document);
		formatAttributeElement(obj.regionFor.feature(LOGICAL_PARTICIPANT__SOURCE_LOWER_BOUND), document);
		formatAttributeElement(obj.regionFor.feature(LOGICAL_PARTICIPANT__SOURCE_UPPER_BOUND), document);
	}

	def dispatch void format(LogicalAssociation obj, extension IFormattableDocument document) {
		obj.formatEntity(document)

		obj.formatListContainer( List.copyOf(obj.participant.toList), document, alwaysTrue);
//		for (c : obj.participant) {
//			c.format
//			c.append[setNewLines(1, 1, 2)]
//		}
	}

	def dispatch void format(LogicalCoordinateSystem lcs, extension IFormattableDocument document) {
		lcs.formatObj(document);
		formatAttribute(lcs.regionFor.keyword('axis:'),
			lcs.regionFor.feature(LOGICAL_COORDINATE_SYSTEM__AXIS_RELATIONSHIP_DESCRIPTION), document);
		formatAttribute(lcs.regionFor.keyword('angleEq:'),
			lcs.regionFor.feature(LOGICAL_COORDINATE_SYSTEM__ANGLE_EQUATION), document);
		formatAttribute(lcs.regionFor.keyword('distanceEq:'),
			lcs.regionFor.feature(LOGICAL_COORDINATE_SYSTEM__DISTANCE_EQUATION), document);
		formatAttribute(lcs.regionFor.keyword('['), lcs.regionFor.keyword(']'), document); // for list of axes
		for (EObject obj : lcs.axis) {
			obj.surround[oneSpace]
		}

	}

	def dispatch void format(LogicalEnumerated obj, extension IFormattableDocument document) {
//		obj.formatObj( document);
		formatAttributeElement(obj.regionFor.feature(UDDL_ELEMENT__NAME ),document);
		formatAttributeElement(obj.regionFor.feature(UDDL_ELEMENT__DESCRIPTION ),document);
		formatAttributeElement(obj.regionFor.feature(LOGICAL_ENUMERATED__STANDARD_REFERENCE), document);
		// To get around the type issues, we convert the EList<LogicalEnumerated> -> List<LogicalEnumerated> -> List<EObject>
		obj.formatListContainer( List.copyOf(obj.label.toList), document, enumContentCheck);
//		for (EObject elem : obj.label) {
//			elem.surround[oneSpace]
//		}
		
	}
	def dispatch void format(LogicalEnumeratedSet obj, extension IFormattableDocument document) {
//		obj.formatObj( document);
		formatAttributeElement(obj.regionFor.feature(UDDL_ELEMENT__NAME ),document);
		formatAttributeElement(obj.regionFor.feature(UDDL_ELEMENT__DESCRIPTION ),document);
		// To get around the type issues, we convert the EList<LogicalEnumerated> -> List<LogicalEnumerated> -> List<EObject>
		obj.formatListContainer( List.copyOf(obj.label.toList), document, enumContentCheck);
		
	}
	
	/**
	 * Labels just need spacing - and to make sure we don't call the formatter for LogicalElement, which 
	 * would insert lines
	 */
	def dispatch void format(LogicalEnumerationLabel obj, extension IFormattableDocument document) {		
		formatAttributeElement(obj.regionFor.feature(UDDL_ELEMENT__NAME ),document);
		formatAttributeElement(obj.regionFor.feature(UDDL_ELEMENT__DESCRIPTION ),document);
	}

	def dispatch void format(LogicalMeasurementSystem obj, extension IFormattableDocument document) {
		formatObj(obj, document);
		/** measurementSystemAxis is a list of references so just print it out as a list */
		for (elem : obj.measurementSystemAxis) {
			elem.surround[oneSpace]
		}

		formatAttribute(obj.regionFor.keyword('coord:'),
			obj.regionFor.feature(LOGICAL_MEASUREMENT_SYSTEM__COORDINATE_SYSTEM), document);
		formatAttribute(obj.regionFor.keyword('extRefStd:'),
			obj.regionFor.feature(LOGICAL_MEASUREMENT_SYSTEM__EXTERNAL_STANDARD_REFERENCE), document);
		formatAttribute(obj.regionFor.keyword('orient:'),
			obj.regionFor.feature(LOGICAL_MEASUREMENT_SYSTEM__ORIENTATION), document);
		for (elem : obj.referencePoint) {
			elem.prepend[setNewLines(1, 1, 2)]
			elem.format
		}
		for (elem : obj.constraint) {
			elem.format
		}
	}

	def dispatch void format(LogicalReferencePoint obj, extension IFormattableDocument document) {
		formatObj(obj, document);
		formatAttribute(obj.regionFor.keyword('landmark:'), obj.regionFor.feature(LOGICAL_REFERENCE_POINT__LANDMARK),
			document);
		for (elem : obj.referencePointPart) {
			elem.format
		}
	}

	def dispatch void format(LogicalReferencePointPart obj, extension IFormattableDocument document) {
		obj.formatSubobj(document)
		obj.regionFor.feature(LOGICAL_REFERENCE_POINT_PART__AXIS).surround[oneSpace]
		obj.regionFor.feature(LOGICAL_REFERENCE_POINT_PART__VALUE).surround[oneSpace]
		obj.regionFor.feature(LOGICAL_REFERENCE_POINT_PART__VALUE_TYPE_UNIT).surround[oneSpace]
	}

	// These should be formatted properly by
	// LogicalMeasurement
	def dispatch void format(LogicalValueTypeUnit obj, extension IFormattableDocument document) {
		formatObj(obj, document);
		formatAttributeElement(obj.regionFor.feature(LOGICAL_VALUE_TYPE_UNIT__VALUE_TYPE), document);
		formatAttributeElement(obj.regionFor.feature(LOGICAL_VALUE_TYPE_UNIT__UNIT), document);
	}

	def dispatch void format(LogicalQuery obj, extension IFormattableDocument document) {
		obj.formatObj(document);
		formatAttributeElement(obj.regionFor.feature(LOGICAL_QUERY__SPECIFICATION), document);
	}

	def dispatch void format(LogicalCompositeQuery obj, extension IFormattableDocument document) {
		obj.formatObj(document);
		formatAttributeElement(obj.regionFor.feature(LOGICAL_COMPOSITE_QUERY__IS_UNION), document);
		for (c : obj.composition) {
			c.format
			c.append[setNewLines(1, 1, 2)]
		}
	}
	def dispatch void format(LogicalQueryComposition obj, extension IFormattableDocument document) {
		formatAttributeElement(obj.regionFor.feature(LOGICAL_QUERY_COMPOSITION__TYPE), document);
		formatAttributeElement(obj.regionFor.feature(LOGICAL_QUERY_COMPOSITION__ROLENAME), document);
	}


	/** Platform */
	def dispatch void format(PlatformElement obj, extension IFormattableDocument document) {
		obj.prepend[setNewLines(1, 1, 2)]
		formatObj(obj, document);
		for (EObject contained : obj.eContents) {
			contained.format
		}
	}

	def dispatch void formatEntity(PlatformEntity obj, extension IFormattableDocument document) {
		obj.formatObj(document);
		for (c : obj.composition) {
			c.format
			c.append[setNewLines(1, 1, 2)]
		}
	}

	def dispatch void format(PlatformEntity obj, extension IFormattableDocument document) {
		obj.formatEntity(document);

	}

	def dispatch void format(PlatformDataType obj, extension IFormattableDocument document) {
		formatAttributeElement(obj.regionFor.feature(UDDL_ELEMENT__NAME), document);
		formatAttributeElement(obj.regionFor.feature(UDDL_ELEMENT__DESCRIPTION), document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_DATA_TYPE__REALIZES), document);
	}

	def dispatch void formatCharacteristic(PlatformCharacteristic obj, extension IFormattableDocument document) {
		formatAttributeElement(obj.regionFor.feature(PLATFORM_CHARACTERISTIC__ROLENAME), document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_CHARACTERISTIC__DESCRIPTION), document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_CHARACTERISTIC__SPECIALIZES), document);
	}

	def dispatch void format(PlatformComposition obj, extension IFormattableDocument document) {
		obj.formatCharacteristic(document);
	}

	def dispatch void format(PlatformParticipant obj, extension IFormattableDocument document) {
		obj.formatCharacteristic(document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_PARTICIPANT__SOURCE_LOWER_BOUND), document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_PARTICIPANT__SOURCE_UPPER_BOUND), document);
	}

	def dispatch void format(PlatformAssociation obj, extension IFormattableDocument document) {
		obj.formatEntity(document)

		for (c : obj.participant) {
			c.format
			c.append[setNewLines(1, 1, 2)]
		}
	}

	def dispatch void format(PlatformQuery obj, extension IFormattableDocument document) {
		obj.formatObj(document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_QUERY__SPECIFICATION), document);
	}

	def dispatch void format(PlatformCompositeQuery obj, extension IFormattableDocument document) {
		obj.formatObj(document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_COMPOSITE_QUERY__IS_UNION), document);
		for (c : obj.composition) {
			c.format
			c.append[setNewLines(1, 1, 2)]
		}
	}
	def dispatch void format(PlatformQueryComposition obj, extension IFormattableDocument document) {
		formatAttributeElement(obj.regionFor.feature(PLATFORM_QUERY_COMPOSITION__TYPE), document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_QUERY_COMPOSITION__ROLENAME), document);
	}
	
	def dispatch void format(PlatformStruct obj, extension IFormattableDocument document) {
		obj.formatObj(document);
		for (c : obj.member) {
			c.format
			c.append[setNewLines(1, 1, 2)]
		}
	}

	def dispatch void format(PlatformStructMember obj, extension IFormattableDocument document) {
		formatAttributeElement(obj.regionFor.feature(PLATFORM_STRUCT_MEMBER__TYPE), document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_STRUCT_MEMBER__ROLENAME), document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_STRUCT_MEMBER__PRECISION), document);
		formatAttributeElement(obj.regionFor.feature(PLATFORM_STRUCT_MEMBER__REALIZES), document);
	}
	
	// TODO: implement for LogicalDataModel, PlatformDataModel, ConceptualEntity, ConceptualAssociation, ConceptualParticipant, ConceptualParticipantPathNode, ConceptualCharacteristicPathNode, ConceptualCompositeQuery, LogicalEnumerated, LogicalEnumeratedSet, LogicalMeasurementSystem, LogicalMeasurementSystemAxis, LogicalReferencePoint, LogicalValueTypeUnit, LogicalMeasurement, LogicalMeasurementAxis, LogicalEntity, LogicalAssociation, LogicalParticipant, LogicalParticipantPathNode, LogicalCharacteristicPathNode, LogicalCompositeQuery, PlatformStruct, PlatformEntity, PlatformAssociation, PlatformParticipant, PlatformParticipantPathNode, PlatformCharacteristicPathNode, PlatformCompositeQuery
}
