// RUN: %clang_cc1 -x objective-c -fsyntax-only -fobjc-default-synthesize-properties -verify %s
// RUN: %clang_cc1 -x objective-c++ -fsyntax-only -fobjc-default-synthesize-properties -verify %s

#if __has_attribute(objc_disable_automatic_synthesis)
__attribute ((objc_disable_automatic_synthesis)) 
#endif
@interface NoAuto // expected-note 2 {{class with specified objc_disable_automatic_synthesis attribute is declared here}}
@property int NoAutoProp; // expected-note 2 {{property declared here}}
@end

@implementation NoAuto  // expected-warning {{property 'NoAutoProp' requires method 'NoAutoProp' to be defined}} \
                        // expected-warning {{property 'NoAutoProp' requires method 'setNoAutoProp:'}}
@end

__attribute ((objc_disable_automatic_synthesis))  // redundant, just for testing
@interface Sub : NoAuto  // expected-note 3 {{class with specified objc_disable_automatic_synthesis attribute is declared here}}
@property (copy) id SubProperty; // expected-note 2 {{property declared here}}
@end

@implementation Sub // expected-warning {{property 'SubProperty' requires method 'SubProperty' to be defined}} \
                    // expected-warning {{property 'SubProperty' requires method 'setSubProperty:' to be defined}}
@end

@interface Deep : Sub
@property (copy) id DeepProperty;
@property (copy) id DeepSynthProperty;
@property (copy) id DeepMustSynthProperty; // expected-note {{property declared here}}
@end

@implementation Deep // expected-warning {{property 'DeepMustSynthProperty' requires method 'setDeepMustSynthProperty:' to be defined}}
@dynamic DeepProperty;
@synthesize DeepSynthProperty;
- (id) DeepMustSynthProperty { return 0; }
@end

__attribute ((objc_disable_automatic_synthesis)) 
@interface Deep(CAT)  // expected-error {{attributes may not be specified on a category}}
@end

__attribute ((objc_disable_automatic_synthesis)) // expected-error {{objc_disable_automatic_synthesis attribute may only be specified on a class}} 
@protocol P @end