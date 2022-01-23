//
//  NoteRepositoryInjection.swift
//  Notes
//
//  Created by 이승주 on 2022/01/19.
//

struct NoteRepositoryInjection {

    private init() { }

    static func injectExpositionRepository() -> NoteRepository {
        return NoteRepositoryDeviceDBImplementation()
    }
}
