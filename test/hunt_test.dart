// Import the test package and Counter class
import 'package:flutter_test/flutter_test.dart';
import 'package:treasurehunt/models/hunt.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Data persistence compliance', () {
    void compareHunts(Hunt h1, Hunt h2) {
      expect(h1.title, h2.title);
      expect(h1.stages[2].hint, h2.stages[2].hint);
    }

    test('Writing an hunt to disk and reading it should get equals hunts',
        () async {
      // Create hunt
      final Hunt hunt1 = Hunt("Test");
      // Add stage
      hunt1.addStage(Stage(
          "Test stage", false, "The answer is : test stage", "test stage"));
      // Create another hunt from json
      final Hunt hunt2 = Hunt("Should not stay");
      await hunt2.readHunt();
      //print(hunt2.toJson());
      // Check that both hunts are equals
      compareHunts(hunt1, hunt2);
    });

    test('Reading an hunt from string should get the correct hunt', () async {
      // Create another hunt from json
      final Hunt hunt = Hunt("Whatever");
      String contents =
          '{"_title":"Test","_stages":[{"title":"First stage","hintIsPlace":false,"hint":"The answer is : next stage","answer":"next stage"},{"title":"Second stage","hintIsPlace":false,"hint":"The answer is : next stage again","answer":"next stage again"},{"title":"Test stage","hintIsPlace":false,"hint":"The answer is : test stage","answer":"test stage"}]}';
      await hunt.fromJson(contents);
      // Check that both hunts are equals
      expect(hunt.title, "Test");
      expect(hunt.stages[2].hint, "The answer is : test stage");
    });
  });
}
