public inherited sharing abstract class QRunner {
    public abstract List<SObject> run(Q query);

    @TestVisible private static QRunner mockRunner;
    public static QRunner getInstance() {
        if (mockRunner != null) {
            return mockRunner;
        }

        if (Evaluator.evaluationSharingMode == Evaluator.SharingMode.WITH) {
            return new WithSharingRunner();
        } else {
            return new WithoutSharingRunner();
        }
    }

    private with sharing class WithSharingRunner extends QRunner {
        public override List<SObject> run(Q query) {
            return Database.query(query.build(), AccessLevel.USER_MODE);
        }
    }

    private without sharing class WithoutSharingRunner extends QRunner {
        public override List<SObject> run(Q query) {
            return Database.query(query.build(), AccessLevel.SYSTEM_MODE);
        }
    }
}
