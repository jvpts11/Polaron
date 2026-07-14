#pragma once

#include "parser/ast.h"

namespace ldp3 {

// Cross-program IPC (spec 2.8). Turns the two halves of an IPC program into ordinary LDP3, before
// generics and semantics run, so everything downstream sees nothing special:
//
//  * every class of a REMOTE bundle (one brought in with --use-remote: its types are known from the
//    .ldh, but its code lives in another process) becomes a PROXY -- a { connection, remote id } pair
//    whose methods serialize their arguments, send a CALL frame and decode the reply;
//  * every program that takes part in IPC gets a DISPATCHER for its own public classes: it decodes an
//    incoming frame, validates the object id and any capability token, calls the real method and
//    encodes the result. A program needs one even as a client -- when it lends out a `T*`, the peer
//    calls back into that object.
//
// The pass generates LDP3 source and parses it, rather than hand-building AST nodes: the generated
// code is then exactly as checked as anything the user writes.
//
// Returns false (and prints the reason) if a signature cannot cross a process boundary.
bool synthesizeIpc(ast::Program& program);

}  // namespace ldp3
